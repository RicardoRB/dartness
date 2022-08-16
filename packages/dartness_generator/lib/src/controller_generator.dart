import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/dartness.dart';
import 'package:source_gen/source_gen.dart';

const _bindType = TypeChecker.fromRuntime(HttpMethod);

class ControllerGenerator extends GeneratorForAnnotation<Controller> {
  final routesVariableName = 'routes';
  final classReturn = (List<ControllerRoute>).toString();
  final _queryParamType = TypeChecker.fromRuntime(QueryParam);
  final _pathParamType = TypeChecker.fromRuntime(PathParam);

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
              refer('<${(ControllerRoute).toString()}>[]')
                  .assignFinal(routesVariableName),
            )
            ..statements.addAll(
              elements.map((methodElement) {
                final bind = _bindType.firstAnnotationOf(methodElement);
                final path =
                    '$controllerPath${bind?.getField('path')?.toStringValue() ?? ''}';
                final bindMethod =
                    bind?.getField('method')?.toStringValue() ?? '';

                final List<Expression> arguments = [];

                for (final param in methodElement.parameters) {
                  final isQuery = _queryParamType.hasAnnotationOfExact(param);
                  final isPath = _pathParamType.hasAnnotationOfExact(param);
                  if (isQuery && isPath) {
                    throw InvalidGenerationSourceError(
                        'Param `${param.name}` cannot be both @QueryParam and @PathParam');
                  }
                  arguments.add(refer((DartnessParam).toString()).newInstance(
                    [
                      literalString(param.name),
                      literalBool(isQuery),
                      literalBool(isPath),
                      literalBool(param.isNamed),
                      literalBool(param.isPositional),
                      literalBool(param.isOptional),
                    ],
                    {
                      'defaultValue': literal(param.defaultValueCode),
                    },
                  ));
                }

                return refer(routesVariableName).property('add').call([
                  refer((ControllerRoute).toString()).newInstance([
                    literalString(bindMethod),
                    literalString(path),
                    refer(methodElement.name),
                    literalList(arguments),
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
