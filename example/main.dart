/// Based on the tutorial found [here](http://releases.llvm.org/2.6/docs/tutorial/JITTutorial1.html).
library llvm.example.a_first_function;

import 'package:code_buffer/code_buffer.dart';
import 'package:llvm/llvm.dart';

main() {
  var mod = new LlvmModule('test');

  // %define i32 mul_add(i32 %x, i32 %y, i32 %z)
  var mulAdd = new LlvmFunction('mul_add', returnType: LlvmType.i32);
  mulAdd.parameters.addAll([
    new LlvmParameter('x', LlvmType.i32),
    new LlvmParameter('y', LlvmType.i32),
    new LlvmParameter('z', LlvmType.i32)
  ]);

  // entry:
  var basicBlock = new LlvmBasicBlock('entry', mulAdd);

  // %tmp = mul i32 %x, %y
  var tmp = new LlvmValue('tmp');
  basicBlock.addStatement(tmp.assign(new LlvmBinaryExpression(
      Instruction.mul,
      new LlvmValue.reference('x', LlvmType.i32),
      new LlvmValue.reference('y', LlvmType.i32))));

  // %tmp2 = add i32 %x, %y
  var tmp2 = new LlvmValue('tmp2');
  basicBlock.addStatement(tmp2.assign(new LlvmBinaryExpression(
      Instruction.add, tmp, new LlvmValue.reference('z', LlvmType.i32))));

  // %ret i32 %tmp2
  basicBlock.addStatement(tmp2.asReturn());

  mulAdd.blocks.add(basicBlock);
  mod.functions.add(mulAdd);

  var buf = new CodeBuffer();
  mod.compile(buf);

  var ir = buf.toString();
  print('Generated LLVM IR:\n');
  print(ir);
}
