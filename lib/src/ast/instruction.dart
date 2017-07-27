class Instruction {
  static const Instruction add = const Instruction('add');
  static const Instruction div = const Instruction('div');
  static const Instruction mul = const Instruction('mul');

  final String name;

  const Instruction(this.name);
}