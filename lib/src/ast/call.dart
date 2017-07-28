part of llvm.src.ast.expression;

abstract class _CallMixin implements LlvmExpression {
  @override
  LlvmExpression call(Iterable<LlvmExpression> arguments) {
    throw new UnsupportedError('Values of type ${type.compile()} are not functions.');
  }
}