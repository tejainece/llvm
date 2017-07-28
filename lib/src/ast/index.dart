part of llvm.src.ast.expression;

abstract class _IndexerMixin implements LlvmExpression {
  @override
  LlvmExpression operator [](LlvmExpression indexer) {
    throw new UnsupportedError('Cannot take an index of ${type.compile()}.');
  }
}
