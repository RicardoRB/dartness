import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/dartness.dart';
import 'package:source_gen/source_gen.dart';

const _bindType = TypeChecker.fromRuntime(Bind);

class ControllerGenerator extends GeneratorForAnnotation<Controller> {
  final routesVariableName = 'routes';
  final classReturn = (List<ControllerRoute>).toString();

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
    final elements = findBindElements(element);
    if (elements.isEmpty) {
      return null;
    }
    final controllerPath = annotation.read('path').stringValue;

    final method = Method(
      (methodBuilder) => methodBuilder
        ..name = 'getRoutes'
        ..returns = refer(classReturn)
        ..body = Block(
          (blocBuilder) => blocBuilder
            ..addExpression(
              refer('<ControllerRoute>[]').assignFinal(routesVariableName),
            )
            ..statements.addAll(
              elements.map((methodElement) {
                final bind = _bindType.firstAnnotationOf(methodElement);
                final path =
                    '$controllerPath${bind?.getField('path')?.toStringValue()}';
                final bindName = bind?.type
                        ?.getDisplayString(withNullability: false)
                        .toUpperCase() ??
                    '';

                return refer(routesVariableName).property('add').call([
                  refer((ControllerRoute).toString()).newInstance([
                    literalString(bindName),
                    literalString(path),
                    refer(methodElement.name),
                  ])
                ]).statement;
              }),
            )
            ..addExpression(refer(routesVariableName).returned),
        ),
    );
    return Extension((extensionBuilder) => extensionBuilder
      ..name = '${element.name}Routes'
      ..on = refer(element.name)
      ..methods.add(method)).accept(DartEmitter()).toString();
  }

  List<ExecutableElement> findBindElements(ClassElement classElement) => [
        ...classElement.methods.where(_bindType.hasAnnotationOf),
        ...classElement.accessors.where(_bindType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
