import 'dart:async';
import 'package:process/process.dart';

class LlvmCompiler {
  final ProcessManager _processManager;

  LlvmCompiler(this._processManager);

  Future<Stream<List<int>>> compile(List<int> data) async {
    var llc = await _processManager.start(['llc', '-']);
    llc.stdin
      ..add(data)
      ..close();

    var code = await llc.exitCode;

    if (code != 0)
      throw new StateError('llc terminated with exit code $code: ${llc.stderr}');

    return llc.stdout;
  }
}
