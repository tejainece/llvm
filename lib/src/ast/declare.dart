import 'package:indenting_buffer/indenting_buffer.dart';
import 'package:meta/meta.dart';
import 'block.dart';
import 'expression.dart';
import 'function.dart';

class LlvmExternalFunction extends LlvmFunction {
  LlvmExternalFunction(String name, {@required LlvmType returnType})
      : super(name, returnType: returnType);

  @override
  List<LlvmBlock> get blocks => throw new UnsupportedError('External functions do not have bodies.');

  @override
  void compile(IndentingBuffer buffer) {
    buffer.write('declare ${returnType.compile()} @$name (');

    for (int i = 0; i < parameters.length; i++) {
      if (i > 0) buffer.withoutIndent(', ');
      var p = parameters[i];
      buffer.withoutIndent(p.compile());
    }

    buffer.withoutIndent(');\n');
  }
}
