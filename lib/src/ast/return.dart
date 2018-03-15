part of llvm.src.ast.expression;

abstract class _ReturnStatementMixin implements LlvmExpression {
  @override
  LlvmStatement asReturn() => new _ReturnStatement(this);
}

class _ReturnStatement extends LlvmStatement {
  final LlvmExpression expression;

  _ReturnStatement(this.expression);

  @override
  void compile(IndentingBuffer buffer) {
    var expr = expression.compileExpression(buffer);
    buffer.writeln('ret ${expression.type.compile()} $expr;');
  }
}
