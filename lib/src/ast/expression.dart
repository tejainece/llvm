library llvm.src.ast.expression;

import 'package:code_buffer/code_buffer.dart';
import 'block.dart';
import 'statement.dart';
part 'binary.dart';
part 'call.dart';
part 'index.dart';
part 'instruction.dart';
part 'literal.dart';
part 'return.dart';
part 'type.dart';
part 'variable.dart';

abstract class LlvmExpression extends LlvmStatement {
  @override
  void compile(CodeBuffer buffer) {
    buffer.writeln(compileExpression(buffer));
  }

  LlvmExpression operator [](LlvmExpression indexer);

  bool get canBeFunctionArgument;

  LlvmType get type;

  String compileExpression(CodeBuffer buffer);

  LlvmStatement asReturn();

  LlvmExpression call(Iterable<LlvmExpression> arguments);
}

class PhiNode extends LlvmExpression with _CallMixin, _IndexerMixin, _ReturnStatementMixin {
  final Map<LlvmExpression, LlvmBlock> incoming = {};
  final LlvmType type;

  PhiNode(this.type);

  @override
  bool get canBeFunctionArgument => false;

  @override
  String compileExpression(CodeBuffer buffer) {
    var b = new StringBuffer('phi ${type.compile()}');
    int i = 0;

    incoming.forEach((key, val) {
      if (i++ > 0)
        b.write(',');
      b.write(' [ ${key.compileExpression(buffer)}, %${val.label} ]');
    });

    return b.toString();
  }
}