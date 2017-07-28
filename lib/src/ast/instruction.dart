class Instruction {
  static const Instruction add = const Instruction('add');
  static const Instruction sub = const Instruction('sub');
  static const Instruction div = const Instruction('div');
  static const Instruction mul = const Instruction('mul');
  static const Instruction and = const Instruction('and');
  static const Instruction or = const Instruction('or');
  static const Instruction xor = const Instruction('xor');

  final String name;

  const Instruction(this.name);
}
