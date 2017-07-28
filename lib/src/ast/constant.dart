import 'package:indenting_buffer/indenting_buffer.dart';
import 'expression.dart';

class LlvmConstant {
  final String name;
  final LlvmExpression value;

  LlvmConstant(this.name, this.value);

  void compile(IndentingBuffer buffer) {
    var expr = value.compileExpression(buffer);
    buffer.writeln('@.$name = private unnamed_addr constant ${value.type.compile()} $expr');
  }
}