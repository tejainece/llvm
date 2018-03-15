import 'package:code_buffer/code_buffer.dart';
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
  void compile(CodeBuffer buffer) {
    buffer.write('declare ${returnType.compile()} @$name (');

    for (int i = 0; i < parameters.length; i++) {
      if (i > 0) buffer.write(', ');
      var p = parameters[i];
      buffer.write(p.compile());
    }

    buffer.write(');\n');
  }
}
