import 'package:indenting_buffer/indenting_buffer.dart';
import 'block.dart';
import 'statement.dart';

class LlvmBasicBlock extends LlvmBlock {
  final List<LlvmStatement> _statements = [];
  final String name;

  LlvmBasicBlock(this.name);

  void compile(IndentingBuffer buffer) {
    buffer.writeln('$name:');
    buffer.indent();

    for (var stmt in _statements)
      stmt.compile(buffer);

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