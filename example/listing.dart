/// Based on the tutorial found [here](https://github.com/f0rki/mapping-high-level-constructs-to-llvm-ir/blob/master/advanced-constructs/listings/listing_7.ll).
library llvm.listing;

import 'package:code_buffer/code_buffer.dart';
import 'package:llvm/llvm.dart';

main() {
  var mod = new LlvmModule('test');
  var foo_context = new LlvmType('foo_context');

  mod.structureTypes[foo_context.name] = new LlvmStructureType()
    ..types.addAll([
      LlvmType.i8.pointer(),
      LlvmType.i32,
      LlvmType.i32,
      LlvmType.i32,
      LlvmType.i32,
    ]);

  var foo_setup = new LlvmFunction('foo_setup', returnType: LlvmType.$void)
    ..parameters.addAll([
      new LlvmParameter('context', foo_context.pointer()),
      new LlvmParameter('start', LlvmType.i32),
      new LlvmParameter('end', LlvmType.i32),
    ]);
  mod.functions.add(foo_setup);

  var block = new LlvmBasicBlock('entry', foo_setup);
  foo_setup.blocks.add(block);

  block.addStatement(LlvmStatement.returnVoid);

  var buf = new CodeBuffer();
  mod.compile(buf);

  var ir = buf.toString();
  print('Generated LLVM IR:\n');
  print(ir);
}
