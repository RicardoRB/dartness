import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/exception.dart';
import 'package:source_gen/source_gen.dart';

class ErrorHandlerGenerator extends GeneratorForAnnotation<ErrorHandler> {
  static final _errorHandlersVariableName = 'catchErrorHandlers';
  static final _classReturn = (List<DartnessCatchError>).toString();
  static final _catchErrorType = TypeChecker.fromRuntime(CatchError);

  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          '@${element.name} cannot target `${element.runtimeType}`.');
    }
    final elements = _findCatchErrorElements(element);
    if (elements.isEmpty) {
      return null;
    }

    final method = Method(
      (methodBuilder) => methodBuilder
        ..name = 'getCatchErrors'
        ..returns = refer(_classReturn)
        ..body = Block(
          (blocBuilder) => blocBuilder
            ..addExpression(
              refer('<${(DartnessCatchError).toString()}>[]')
                  .assignFinal(_errorHandlersVariableName),
            )
            ..statements.addAll(
              elements.map((methodElement) {
                final methodRefer = _methodElementToMethodRefer(methodElement);
                return refer(_errorHandlersVariableName)
                    .property('add')
                    .call([methodRefer]).statement;
              }),
            )
            ..addExpression(refer(_errorHandlersVariableName).returned),
        ),
    );
    return Extension((extensionBuilder) => extensionBuilder
      ..name = '${element.name}Catchers'
      ..on = refer(element.name)
      ..methods.add(method)).accept(DartEmitter()).toString();
  }

  Expression _methodElementToMethodRefer(ExecutableElement methodElement) {
    final catchErrorAnnotation =
        _catchErrorType.firstAnnotationOfExact(methodElement);

    final errorTypes = catchErrorAnnotation?.getField('errors');
    final errors = errorTypes?.toListValue()?.map((errorType) {
          final typeName = errorType
                  .toTypeValue()
                  ?.getDisplayString(withNullability: false) ??
              '';
          final typeCode = Code(typeName);
          return CodeExpression(typeCode);
        }) ??
        [];
    final methodRefer = refer((DartnessCatchError).toString()).newInstance([
      literalList(errors),
      refer(methodElement.name),
    ]);
    return methodRefer;
  }

  List<ExecutableElement> _findCatchErrorElements(ClassElement classElement) => [
        ...classElement.methods.where(_catchErrorType.hasAnnotationOf),
        ...classElement.accessors.where(_catchErrorType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
