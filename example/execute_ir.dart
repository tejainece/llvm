/// Use the LLVM toolchain to run code via `lli`.
library llvm_example.execute_ir;

import 'dart:async';
import 'dart:io';
import 'package:code_buffer/code_buffer.dart';
import 'package:file/local.dart';
import 'package:llvm/llvm.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'main.dart';

const LlvmToolchain llvmToolchain =  const LlvmToolchain(
    const LocalFileSystem(),
    const LocalPlatform(),
    const LocalProcessManager(),
  );

main() async {
  var mod = helloWorld();
  var buf = new CodeBuffer();
  mod.compile(buf);

  var ir = new Stream<List<int>>.fromIterable([buf.toString().codeUnits]);
  ir = llvmToolchain.optimizeIR(ir);
  await stdout.addStream(llvmToolchain.executeIR(ir));
}
