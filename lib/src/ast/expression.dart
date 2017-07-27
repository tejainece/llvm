library llvm.src.ast.expression;
import 'package:indenting_buffer/indenting_buffer.dart';
import 'instruction.dart';
import 'statement.dart';
import 'type.dart';
part 'binary.dart';
part 'return.dart';
part 'variable.dart';

abstract class LlvmExpression extends LlvmStatement {
  @override
  void compile(IndentingBuffer buffer) {
    buffer.writeln(compileExpression(buffer));
  }

  LlvmType get type;

  String compileExpression(IndentingBuffer buffer);

  LlvmStatement asReturn();
}