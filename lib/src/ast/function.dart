import 'package:code_buffer/code_buffer.dart';
import 'package:meta/meta.dart';
import 'block.dart';
import 'expression.dart';
import 'parameter.dart';

class LlvmFunction {
  final List<LlvmBlock> blocks = [];
  final List<LlvmParameter> parameters = [];
  final String name;
  final LlvmType returnType;

  LlvmFunction(this.name, {@required this.returnType});

  void compile(CodeBuffer buffer) {
    buffer.write('define ${returnType.compile()} @$name (');

    for (int i = 0; i < parameters.length; i++) {
      if (i > 0) buffer.write(', ');
      var p = parameters[i];
      buffer.write(p.compile());
    }

    buffer.write(') {\n');

    for (int i = 0; i < blocks.length; i++) {
      if (i > 0) buffer.write('\n');
      blocks[i].compile(buffer);
    }

    buffer.writeln('}');
  }
}
