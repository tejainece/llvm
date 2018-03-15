import 'expression.dart';

class LlvmParameter {
  final String name;
  final LlvmType type;

  LlvmParameter(this.name, this.type);

  String compile() => '${type.compile()} %$name';
}
