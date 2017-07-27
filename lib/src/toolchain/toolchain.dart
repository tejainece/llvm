import 'package:process/process.dart';
import 'compiler.dart';

class LlvmToolchain {
  LlvmCompiler _compiler;

  LlvmToolchain(ProcessManager processManager) {
    _compiler = new LlvmCompiler(processManager);
  }

  /// Compiles LLVM IR into machine code.
  LlvmCompiler get compiler => _compiler;
}