import 'package:indenting_buffer/indenting_buffer.dart';
import 'function.dart';

class LlvmModule {
  final List<LlvmFunction> functions = [];
  final String name;

  LlvmModule(this.name);

  void compile(IndentingBuffer buffer) {
    int i = 0;

    for (var fn in functions) {
      if (i > 0)
        buffer.writeln();
      fn.compile(buffer);
    }
  }
}