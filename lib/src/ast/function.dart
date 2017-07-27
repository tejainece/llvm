import 'package:indenting_buffer/indenting_buffer.dart';
import 'package:meta/meta.dart';
import 'block.dart';
import 'parameter.dart';
import 'type.dart';

class LlvmFunction {
  final List<LlvmBlock> blocks = [];
  final List<LlvmParameter> parameters = [];
  final String name;
  final LlvmType returnType;

  LlvmFunction(this.name, {@required this.returnType});

  void compile(IndentingBuffer buffer) {
    buffer.write('define ${returnType.compile()} @$name (');

    for (int i = 0; i < parameters.length; i++) {
     if (i > 0)
       buffer.withoutIndent(', ');
     var p = parameters[i];
     buffer.withoutIndent(p.compile());
    }

    buffer.withoutIndent(') {\n');

    for (int i = 0; i < blocks.length; i++) {
      if (i > 0)
        buffer.withoutIndent('\n');
      blocks[i].compile(buffer);
    }

    buffer.writeln('}');
  }
}
