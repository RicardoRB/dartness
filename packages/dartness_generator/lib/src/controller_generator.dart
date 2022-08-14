import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/dartness.dart';
import 'package:source_gen/source_gen.dart';

const _bindType = TypeChecker.fromRuntime(Bind);

class ControllerGenerator extends GeneratorForAnnotation<Controller> {
  @override
  String? generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          '@${element.name} cannot target `${element.runtimeType}`.');
    }
    final elements = findBindElements(element);
    if (elements.isEmpty) {
      return null;
    }
    final routerVariableName = 'router';
    final classMethodRouter = (DefaultDartnessRouter).toString();

    final method = Method(
      (methodBuilder) => methodBuilder
        ..name = 'getRouter'
        ..returns = refer(classMethodRouter)
        ..body = Block(
          (blocBuilder) => blocBuilder
            ..addExpression(
              refer(classMethodRouter)
                  .newInstance([]).assignFinal(routerVariableName),
            )
            ..statements.addAll(
              elements.map((methodElement) {
                final bind = _bindType.firstAnnotationOf(methodElement);
                final path = bind?.getField('path')?.toStringValue() ?? '';
                final name = bind?.type
                        ?.getDisplayString(withNullability: false)
                        .toUpperCase() ??
                    '';
                return refer(routerVariableName).property('add').call([
                  literalString(name),
                  literalString(path),
                  refer((DartnessRouterHandler).toString()).newInstance([
                    refer('this').property(methodElement.name),
                  ]),
                ]).statement;
              }),
            )
            ..addExpression(refer(routerVariableName).returned),
        ),
    );
    return Extension((extensionBuilder) => extensionBuilder
      ..name = '\$${element.name}Router'
      ..on = refer(element.name)
      ..methods.add(method)).accept(DartEmitter()).toString();
  }

  List<ExecutableElement> findBindElements(ClassElement classElement) => [
        ...classElement.methods.where(_bindType.hasAnnotationOf),
        ...classElement.accessors.where(_bindType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
