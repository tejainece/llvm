import 'package:indenting_buffer/indenting_buffer.dart';
import 'block.dart';
import 'function.dart';
import 'statement.dart';

class LlvmBasicBlock extends LlvmBlock {
  final List<LlvmStatement> _statements = [];
  final String label;
  final LlvmFunction parent;

  LlvmBasicBlock(this.label, this.parent);

  void compile(IndentingBuffer buffer) {
    buffer.writeln('$label:');
    buffer.indent();

    for (var stmt in _statements) stmt.compile(buffer);

    buffer.outdent();
  }

  @override
  void addStatements(Iterable<LlvmStatement> statements) {
    _statements.addAll(statements);
  }

  @override
  void addStatement(LlvmStatement statement) {
    _statements.add(statement);
  }
}
