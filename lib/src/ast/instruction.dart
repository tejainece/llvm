part of llvm.src.ast.expression;

class Instruction {
  static const Instruction add = const Instruction('add');
  static const Instruction sub = const Instruction('sub');
  static const Instruction div = const Instruction('div');
  static const Instruction mul = const Instruction('mul');
  static const Instruction and = const Instruction('and');
  static const Instruction or = const Instruction('or');
  static const Instruction xor = const Instruction('xor');
  static const Instruction eq = const Instruction('eq');

  final String name;

  const Instruction(this.name);

  Instruction prepend(String s) => new Instruction('$s $name');

  Instruction variant(String s) => new Instruction('$s$name');

  Instruction append(String s) => new Instruction('$name $s');

  LlvmExpression invoke(LlvmType returnType,
          [Iterable<LlvmExpression> arguments = const []]) =>
      new _InstructionExpression(returnType, this, arguments ?? []);
}

class _InstructionExpression extends LlvmExpression
    with _CallMixin, _ReturnStatementMixin, _IndexerMixin {
  final LlvmType type;
  final Instruction instruction;
  final Iterable<LlvmExpression> arguments;

  _InstructionExpression(this.type, this.instruction, this.arguments);

  @override
  bool get canBeFunctionArgument => false;

  @override
  String compileExpression(IndentingBuffer buffer) {
    if (arguments.isEmpty) return instruction.name;
    var args = arguments.map((e) => e.compileExpression(buffer));
    return '${instruction.name} ' + args.join(', ');
  }
}
