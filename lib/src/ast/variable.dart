part of llvm.src.ast.expression;

class LlvmValue extends LlvmExpression with _ReturnStatementMixin {
  LlvmExpression _value;

  final String name;

  LlvmValue(this.name);

  factory LlvmValue.reference(String name, LlvmType type) =>
      new _LlvmValueReference(name, type);

  @override
  LlvmType get type => _value?.type;

  @override
  String compileExpression(_) {
    return '%$name';
  }

  LlvmStatement assign(LlvmExpression value) {
    _value = value;
    return new _AssignStatement(this);
  }
}

class _LlvmValueReference extends LlvmValue {
  @override
  final LlvmType type;

  _LlvmValueReference(String name, this.type) : super(name);
}

class _AssignStatement extends LlvmStatement {
  final LlvmValue value;

  _AssignStatement(this.value);

  @override
  void compile(IndentingBuffer buffer) {
    var v = value._value.compileExpression(buffer);
    buffer.writeln('%${value.name} = $v');
  }
}
