library llvm.src.ast.expression;

import 'package:indenting_buffer/indenting_buffer.dart';
import 'block.dart';
import 'instruction.dart';
import 'statement.dart';
import 'type.dart';
part 'binary.dart';
part 'call.dart';
part 'index.dart';
part 'literal.dart';
part 'return.dart';
part 'variable.dart';

abstract class LlvmExpression extends LlvmStatement {
  @override
  void compile(IndentingBuffer buffer) {
    buffer.writeln(compileExpression(buffer));
  }

  LlvmExpression operator [](LlvmExpression indexer);

  bool get canBeFunctionArgument;

  LlvmType get type;

  String compileExpression(IndentingBuffer buffer);

  LlvmStatement asReturn();

  LlvmExpression call(Iterable<LlvmExpression> arguments);
}

class OpcodeExpression extends LlvmExpression
    with _CallMixin, _ReturnStatementMixin, _IndexerMixin {
  final LlvmType type;
  final String opcode;
  final Iterable<LlvmExpression> arguments;

  OpcodeExpression(this.type, this.opcode, [this.arguments = const []]);

  @override
  bool get canBeFunctionArgument => false;

  @override
  String compileExpression(IndentingBuffer buffer) {
    if (arguments.isEmpty) return opcode;
    var args = arguments.map((e) => e.compileExpression(buffer));
    return '$opcode ' + args.join(', ');
  }
}

class PhiNode extends LlvmExpression with _CallMixin, _IndexerMixin, _ReturnStatementMixin {
  final Map<LlvmExpression, LlvmBlock> incoming = {};
  final LlvmType type;

  PhiNode(this.type);

  @override
  bool get canBeFunctionArgument => false;

  @override
  String compileExpression(IndentingBuffer buffer) {
    var b = new StringBuffer('phi ${type.compile()}');
    int i = 0;

    incoming.forEach((key, val) {
      if (i++ > 0)
        b.write(',');
      b.write(' [ ${key.compileExpression(buffer)}, ${val.label} ]');
    });

    return b.toString();
  }
}