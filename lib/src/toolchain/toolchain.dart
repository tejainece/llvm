import 'dart:async';
import 'dart:convert';
import 'package:file/file.dart';
import 'package:path/path.dart' as p;
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:random_string/random_string.dart' as rs;

class LlvmToolchain {
  final FileSystem fileSystem;
  final Platform platform;
  final ProcessManager processManager;

  const LlvmToolchain(this.fileSystem, this.platform, this.processManager);

  /// Compiles LLVM IR into Assembly code.
  Stream<List<int>> compileIRToAssemblyCode(Stream<List<int>> ir) {
    var c = new StreamController<List<int>>();

    processManager.start(['llc', '-']).then((llc) async {
      await ir.pipe(llc.stdin);

      var code = await llc.exitCode;

      if (code != 0)
        throw new StateError(
            'llc terminated with exit code $code: ${await llc.stderr.map((buf) => new String.fromCharCodes(buf)).join()}');

      await llc.stdout.pipe(c);
    }).catchError(c.addError);

    return c.stream;
  }

  /// Compiles LLVM IR into an object file.
  Stream<List<int>> compileIRToMachineCode(Stream<List<int>> ir) {
    var c = new StreamController<List<int>>();

    processManager.start(['llc', '--filetype=obj', '-']).then((llc) async {
      await ir.pipe(llc.stdin);

      var code = await llc.exitCode;

      if (code != 0)
        throw new StateError(
            'llc terminated with exit code $code: ${await llc.stderr.map((buf) => new String.fromCharCodes(buf)).join()}');

      await llc.stdout.pipe(c);
    }).catchError(c.addError);

    return c.stream;
  }

  /// Optimizes LLVM IR code.
  Stream<List<int>> optimizeIR(Stream<List<int>> ir) {
    var c = new StreamController<List<int>>();

    processManager.start(['opt', '-S', '-']).then((opt) async {
      await ir.pipe(opt.stdin);

      var code = await opt.exitCode;

      if (code != 0)
        throw new StateError(
            'opt terminated with exit code $code: ${await opt.stderr.map((buf) => new String.fromCharCodes(buf)).join()}');

      await opt.stdout.pipe(c);
    }).catchError(c.addError);

    return c.stream;
  }

  Future linkToExecutable(Stream<List<int>> outputStream,
      {List<String> includeLibraries, String outputPath}) async {
    var cmd = [platform.isWindows ? 'lld-link' : 'ld.lld', '/entry:main'];

    if (includeLibraries?.isNotEmpty == true)
      cmd.addAll(includeLibraries.map<String>((s) => '/implib:$s'));

    if (outputPath != null) cmd.add('/out:$outputPath');

    var tempFile = fileSystem.file(p.join(
        fileSystem.systemTempDirectory.absolute.path,
        rs.randomAlpha(10) + (platform.isWindows ? '.obj' : '.o')));
    var sink = tempFile.openWrite();
    await outputStream.pipe(sink);

    cmd.add(tempFile.absolute.path);

    var lld = await processManager.start(cmd);

    var code = await lld.exitCode;

    if (code != 0)
      throw new StateError(
          'lld terminated with exit code $code: ${await lld.stderr.map((buf) => new String.fromCharCodes(buf)).join()}');
  }

  /// JIT-compiles and runs IR code.
  ///
  /// Returns the stdout of `lli`, unless an error occurs.
  Stream<List<int>> executeIR(Stream<List<int>> ir,
      [Iterable<String> args = const []]) {
    var c = new StreamController<List<int>>();

    processManager.start(['lli', '-']..addAll(args ?? [])).then((lli) async {
      await ir.pipe(lli.stdin);

      var code = await lli.exitCode;

      if (code != 0)
        c.addError(new StateError(
            'Program terminated with exit code $code: ${await lli.stderr.map((buf) => new String.fromCharCodes(buf)).join()}'));

      await lli.stdout.pipe(c);
    }).catchError(c.addError);

    return c.stream;
  }
}
