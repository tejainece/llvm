part of llvm.src.ast.expression;

class LlvmType {
  static const LlvmType $void = const LlvmType('void');
  static const LlvmType i1 = const LlvmType('i1');
  static const LlvmType i8 = const LlvmType('i8');
  static const LlvmType i16 = const LlvmType('i16');
  static const LlvmType i32 = const LlvmType('i32');
  static const LlvmType i64 = const LlvmType('i64');
  static const LlvmType half = const LlvmType('half');
  static const LlvmType float = const LlvmType('float');
  static const LlvmType double = const LlvmType('double');
  static const LlvmType fp128 = const LlvmType('fp128');
  static const LlvmType x86_fp80 = const LlvmType('x86_fp80');
  static const LlvmType ppc_fp128 = const LlvmType('ppc_fp128');
  static const LlvmType x86_mmx = const LlvmType('x86_mmx');
  static const LlvmType label = const LlvmType('label');
  static const LlvmType token = const LlvmType('token');
  static const LlvmType metadata = const LlvmType('metadata');
  static const LlvmType opaque = const LlvmType('type opaque');

  final String name;

  const LlvmType(this.name);

  LlvmType get innermost => this;

  String compile() => name;

  LlvmType pointer() => new _PointerType(this);

  LlvmType array(int size) => new _ArrayType(this, size);

  LlvmType vector(int size) => new _VectorType(this, size);
}

class _PointerType extends LlvmType {
  final LlvmType innerType;

  _PointerType(this.innerType) : super('ptr (${innerType.name})');

  @override
  LlvmType get innermost {
    var _t = innerType;

    while (_t.innermost != _t)
      _t = _t.innermost;

    return _t;
  }

  @override
  String compile() => '${innerType.compile()}*';
}

class _ArrayType extends LlvmType {
  final LlvmType innerType;
  final int size;

  _ArrayType(this.innerType, this.size)
      : super('array[$size] (${innerType.name})');

  @override
  LlvmType get innermost {
    var _t = innerType;

    while (_t.innermost != _t)
      _t = _t.innermost;

    return _t;
  }

  @override
  String compile() {
    return '[$size x ${innerType.compile()}]';
  }
}

class _VectorType extends LlvmType {
  final LlvmType innerType;
  final int size;

  _VectorType(this.innerType, this.size)
      : super('vector<$size> (${innerType.name})');

  @override
  LlvmType get innermost {
    var _t = innerType;

    while (_t.innermost != _t)
      _t = _t.innermost;

    return _t;
  }

  @override
  String compile() {
    return '<$size x ${innerType.compile()}>';
  }
}

class LlvmStructureType extends LlvmType {
  String _name;
  final List<LlvmType> types = [];

  LlvmStructureType() : super(null);

  factory LlvmStructureType.packed() => new _PackedLlvmStructureType();

  @override
  String get name =>
      _name ??= ('{ ' + types.map<String>((t) => t.compile()).join(', ') + ' }');

  @override
  String compile() => name;

  LlvmExpression instance(Iterable<LlvmExpression> arguments) {
    return new _LlvmStructInstance(this, arguments);
  }
}

class _PackedLlvmStructureType extends LlvmStructureType {
  String _name;

  @override
  String get name => _name ??= ('<' + super.name + '>');
}

class _LlvmStructInstance extends LlvmExpression with _CallMixin, _IndexerMixin, _ReturnStatementMixin {
  final LlvmStructureType type;
  final Iterable<LlvmExpression> arguments;

  _LlvmStructInstance(this.type, this.arguments);

  bool get isPacked => type is _PackedLlvmStructureType;

  @override
  bool get canBeFunctionArgument => true;

  @override
  String compileExpression(CodeBuffer buffer) {
    var b = new StringBuffer('{');
    int i = 0;

    for (var arg in arguments) {
      if (i++ > 0) b.write(',');
      b.write(' ${arg.type.compile()} ${arg.compileExpression(buffer)} ');
    }

    return b.toString() + '}';
  }
}

class LlvmFunctionType extends LlvmType {
  String _name;
  final String functionName;
  final List<LlvmType> parameters = [];
  final LlvmType returnType;

  LlvmFunctionType(this.functionName, this.returnType) : super(null);

  @override
  String get name => _name ??= ('${returnType.compile()} (' +
      parameters.map<String>((t) => t.compile()).join(', ') +
      ')');
}
