part of llvm.src.ast.expression;

class LlvmValue extends LlvmExpression with _ReturnStatementMixin {
  LlvmExpression _value;

  final String name;
  final bool constant;

  LlvmValue(this.name, {this.constant});

  factory LlvmValue.reference(String name, LlvmType type, {bool constant}) =>
      new _LlvmValueReference(name, type, constant: constant);

  @override
  bool get canBeFunctionArgument => true;

  @override
  LlvmType get type => _value?.type;

  @override
  String compileExpression(_) {
    return constant == true ? '@.$name' : '%$name';
  }

  @override
  LlvmExpression operator [](LlvmExpression indexer) {
    return new _GetElementPtrExpression(this, indexer);
  }

  @override
  LlvmExpression call(Iterable<LlvmExpression> arguments) {
    if (type == null)
      throw new StateError(
          'The type of the variable "%$name" is unknown, so it cannot be called as a function.');
    else if (type is! LlvmFunctionType)
      throw new UnsupportedError(
          '"%$name" cannot be called as a function - its type is ${type.compile()}.');
    else {
      var fnType = type as LlvmFunctionType;

      if (arguments.length != fnType.parameters.length)
        throw new ArgumentError(
            'The function "%${fnType.functionName}" expects ${fnType.parameters} argument(s), but was called with ${arguments.length}.');

      // TODO: Type safety???
      return new _CallExpression(fnType, arguments);
    }
  }

  LlvmStatement assign(LlvmExpression value) {
    _value = value;
    return new _AssignStatement(this);
  }

  LlvmStatement allocate() {
    return new _AllocateStatement(this);
  }

  LlvmStatement store(LlvmExpression value) {
    _value = value;
    return new _StoreStatement(this);
  }
}

class _GetElementPtrExpression extends LlvmExpression
    with _CallMixin, _IndexerMixin, _ReturnStatementMixin {
  final LlvmValue value;
  final LlvmExpression indexer;

  _GetElementPtrExpression(this.value, this.indexer);

  @override
  bool get canBeFunctionArgument => false;

  @override
  LlvmType get type => value.type.pointer();

  @override
  String compileExpression(IndentingBuffer buffer) {
    var expr = indexer.compileExpression(buffer);
    var type = value.type.compile();
    // TODO: Remove first type for LLVM 3.7+
    return 'getelementptr $type* ${value.compileExpression(buffer)}, i8 0, ${indexer.type.compile()} $expr';
  }
}

class _LlvmValueReference extends LlvmValue {
  @override
  final LlvmType type;

  _LlvmValueReference(String name, this.type, {bool constant})
      : super(name, constant: constant);
}

class _AssignStatement extends LlvmStatement {
  final LlvmValue value;

  _AssignStatement(this.value);

  @override
  void compile(IndentingBuffer buffer) {
    var v = value._value.compileExpression(buffer);
    if (value._value is LlvmLiteralExpression)
      v = '${value._value.type.compile()} ' + v;
    buffer.writeln('%${value.name} = $v;');
  }
}

class _AllocateStatement extends LlvmStatement {
  final LlvmValue value;

  _AllocateStatement(this.value);

  @override
  void compile(IndentingBuffer buffer) {
    buffer.writeln('%${value.name} = alloca ${value.type.compile()};');
  }
}

class _StoreStatement extends LlvmStatement {
  final LlvmValue value;

  _StoreStatement(this.value);

  @override
  void compile(IndentingBuffer buffer) {
    // store i32 5, i32* %a
    buffer.writeln(
        'store ${value.type.compile()} ${value._value.compileExpression(buffer)}, ${value.type.pointer().compile()} %${value.name};');
  }
}

class _CallExpression extends LlvmExpression
    with _CallMixin, _IndexerMixin, _ReturnStatementMixin {
  final LlvmFunctionType functionType;
  final Iterable<LlvmExpression> arguments;

  _CallExpression(this.functionType, this.arguments);

  @override
  bool get canBeFunctionArgument => false;

  @override
  LlvmType get type => functionType.returnType;

  @override
  String compileExpression(IndentingBuffer buffer) {
    var args = arguments.map<String>((e) => e.compileExpression(buffer));
    var b = new StringBuffer(
        'call ${functionType.returnType.compile()} @${functionType.functionName} (');

    for (int i = 0; i < args.length; i++) {
      if (i > 0) b.write(', ');
      var arg = arguments.elementAt(i);
      b.write('${arg.type.innermost.compile()} ' + args.elementAt(i));
    }

    b.write(')');
    return b.toString();
  }
}
