import 'package:code_buffer/code_buffer.dart';

abstract class LlvmStatement {
  static const LlvmStatement returnVoid = const _LlvmReturnVoidStatement();

  void compile(CodeBuffer buffer);
}

class _LlvmReturnVoidStatement implements LlvmStatement {
  const _LlvmReturnVoidStatement();

  @override
  void compile(CodeBuffer buffer) {
    buffer.writeln('ret void;');
  }
}