part of llvm.src.ast.expression;

abstract class Literals {
  static LlvmExpression $bool(bool value) =>
      new LlvmLiteralExpression(value ? 'true' : 'false', LlvmType.i1);

  static LlvmExpression $int(int value) => new LlvmLiteralExpression(
      value.toString(), new LlvmType('i${value.bitLength + 1}'));

  static LlvmExpression i1(int value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.i1);

  static LlvmExpression i8(int value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.i8);

  static LlvmExpression i16(int value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.i16);

  static LlvmExpression i32(int value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.i32);

  static LlvmExpression i64(int value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.i64);

  static LlvmExpression half(double value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.half);

  static LlvmExpression float(double value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.float);

  static LlvmExpression $double(double value) =>
      new LlvmLiteralExpression(value.toString(), LlvmType.double);

  static LlvmExpression string(String value) =>
      new _StringLiteralExpression(value);
}

class LlvmLiteralExpression extends LlvmExpression
    with _CallMixin, _IndexerMixin, _ReturnStatementMixin {
  final String text;
  final LlvmType type;

  LlvmLiteralExpression(this.text, this.type);

  @override
  bool get canBeFunctionArgument => true;

  @override
  String compileExpression(CodeBuffer buffer) {
    return '$text';
  }
}

class _StringLiteralExpression extends LlvmLiteralExpression {
  String _replaced;
  final String value;

  _StringLiteralExpression(this.value)
      : super(null, LlvmType.i8.array(value.length + 1)) {
    _replaced = 'c"' +
        value
            .replaceAll('\\', '\\\\')
            .replaceAll('\b', '\\08')
            .replaceAll('\f', '\\0C')
            .replaceAll('\n', '\\0A')
            .replaceAll('\r', '\\0D')
            .replaceAll('\t', '\\09')
            .replaceAll('"', '\\"') +
        '\\00"';
  }

  @override
  bool get canBeFunctionArgument => false;

  @override
  String compileExpression(CodeBuffer buffer) {
    return _replaced;
  }
}
