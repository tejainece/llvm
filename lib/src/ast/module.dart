import 'package:code_buffer/code_buffer.dart';
import 'constant.dart';
import 'expression.dart';
import 'function.dart';

class LlvmModule {
  final List<LlvmConstant> constants = [];
  final List<LlvmFunction> functions = [];
  final Map<String, LlvmStructureType> structureTypes = {};
  final String name;

  LlvmModule(this.name);

  void compile(CodeBuffer buffer) {
    int i = 0;

    for (var constant in constants) {
      if (i++ > 0) buffer.writeln();
      constant.compile(buffer);
    }

    structureTypes.forEach((name, type) {
      if (i++ > 0) buffer.writeln();
      buffer.writeln('%struct.$name = type ${type.compile()}');
    });

    for (var fn in functions) {
      if (i++ > 0) buffer.writeln();
      fn.compile(buffer);
    }
  }
}
