import 'package:indenting_buffer/indenting_buffer.dart';

abstract class LlvmStatement {
  static const LlvmStatement returnVoid = const _LlvmReturnVoidStatement();

  void compile(IndentingBuffer buffer);
}

class _LlvmReturnVoidStatement implements LlvmStatement {
  const _LlvmReturnVoidStatement();

  @override
  void compile(IndentingBuffer buffer) {
    buffer.writeln('ret void;');
  }
}