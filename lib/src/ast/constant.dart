import 'package:code_buffer/code_buffer.dart';
import 'expression.dart';

class LlvmConstant {
  final String name;
  final LlvmExpression value;

  LlvmConstant(this.name, this.value);

  void compile(CodeBuffer buffer) {
    var expr = value.compileExpression(buffer);
    buffer.writeln('@.$name = private unnamed_addr constant ${value.type.compile()} $expr');
  }
}