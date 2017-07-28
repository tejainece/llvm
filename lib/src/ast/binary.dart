part of llvm.src.ast.expression;

class LlvmBinaryExpression extends LlvmExpression with _CallMixin, _IndexerMixin {
  final Instruction instruction;
  final LlvmExpression left, right;

  LlvmBinaryExpression(this.instruction, this.left, this.right);

  @override
  bool get canBeFunctionArgument => false;

  @override
  LlvmType get type => left.type;

  @override
  String compileExpression(IndentingBuffer buffer) {
    var l = left.compileExpression(buffer);
    var r = right.compileExpression(buffer);
    return '${instruction.name} ${type.compile()} $l, $r';
  }

  @override
  LlvmStatement asReturn() {
    throw new UnsupportedError('Cannot return binary expressions.');
  }
}
