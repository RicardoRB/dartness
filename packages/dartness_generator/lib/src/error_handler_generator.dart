import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/exception.dart';
import 'package:source_gen/source_gen.dart';

class ErrorHandlerGenerator extends GeneratorForAnnotation<ErrorHandler> {
  static final _errorHandlersVariableName = 'catchErrorHandlers';
  static final _classReturn = (List<DartnessErrorHandler>).toString();
  static final _catchErrorType = TypeChecker.fromRuntime(CatchError);
  static final _httpStatusExceptionType =
      TypeChecker.fromRuntime(HttpStatusException);

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
    final elements = findCatchErrorElements(element);
    if (elements.isEmpty) {
      return null;
    }

    final method = Method(
      (methodBuilder) => methodBuilder
        ..name = 'getCatchHandlers'
        ..returns = refer(_classReturn)
        ..body = Block(
          (blocBuilder) => blocBuilder
            ..addExpression(
              refer('<${(DartnessErrorHandler).toString()}>[]')
                  .assignFinal(_errorHandlersVariableName),
            )
            ..statements.addAll(
              elements.map((methodElement) {
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

                return refer(_errorHandlersVariableName).property('add').call([
                  refer((DartnessErrorHandler).toString()).newInstance([
                    literalList(errors),
                    refer(methodElement.name),
                  ])
                ]).statement;
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

  List<ExecutableElement> findCatchErrorElements(ClassElement classElement) => [
        ...classElement.methods.where(_catchErrorType.hasAnnotationOf),
        ...classElement.accessors.where(_catchErrorType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
