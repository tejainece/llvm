import 'package:indenting_buffer/indenting_buffer.dart';
import 'statement.dart';

abstract class LlvmBlock {
  void compile(IndentingBuffer buffer);
  void addStatement(LlvmStatement statement);
  void addStatements(Iterable<LlvmStatement> statements);
}