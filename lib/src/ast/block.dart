import 'package:indenting_buffer/indenting_buffer.dart';
import 'expression.dart';
import 'function.dart';
import 'statement.dart';

abstract class LlvmBlock {
  LlvmFunction get parent;
  String get label;
  void compile(IndentingBuffer buffer);
  void addStatement(LlvmStatement statement);
  void addStatements(Iterable<LlvmStatement> statements);

  /// Produces a `br` statement, jumping to this block.
  LlvmStatement asBreak() => new _BreakStatement(this);
}

class _BreakStatement extends LlvmStatement {
  final LlvmBlock destination;

  @override
  void compile(IndentingBuffer buffer) {
    buffer.writeln('br label %${destination.label};');
  }

  _BreakStatement(this.destination);
}

class ConditionalBreakStatement extends LlvmStatement {
  final LlvmExpression condition;
  final LlvmBlock then;
  final LlvmBlock otherwise;

  ConditionalBreakStatement(this.condition, this.then, this.otherwise);

  @override
  void compile(IndentingBuffer buffer) {
    // br i1 %ifcond, label %then, label %else
    var ifCond = condition.compileExpression(buffer);
    buffer.writeln('br ${condition.type.compile()} $ifCond, label %${then.label}, label %${otherwise.label};');
  }
}