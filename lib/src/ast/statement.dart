import 'package:indenting_buffer/indenting_buffer.dart';

abstract class LlvmStatement {
  void compile(IndentingBuffer buffer);
}