import 'dart:mirrors';

abstract class BindHandler {
  Function handle(ClassMirror clazzDeclaration, MethodMirror method);
}
