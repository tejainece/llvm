class LlvmType {
  static const LlvmType i32 = const LlvmType('i32');
  static const LlvmType i64 = const LlvmType('i64');

  final String name;

  const LlvmType(this.name);

  String compile() => name;
}