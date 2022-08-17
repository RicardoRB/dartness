import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/dartness.dart';
import 'package:source_gen/source_gen.dart';

class ControllerGenerator extends GeneratorForAnnotation<Controller> {
  static final _routesVariableName = 'routes';
  static final _classReturn = (List<ControllerRoute>).toString();
  static final _queryParamType = TypeChecker.fromRuntime(QueryParam);
  static final _pathParamType = TypeChecker.fromRuntime(PathParam);
  static final _httpMethodType = TypeChecker.fromRuntime(HttpMethod);
  static final _httpCodeType = TypeChecker.fromRuntime(HttpCode);

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
        ..returns = refer(_classReturn)
        ..body = Block(
          (blocBuilder) => blocBuilder
            ..addExpression(
              refer('<${(ControllerRoute).toString()}>[]')
                  .assignFinal(_routesVariableName),
            )
            ..statements.addAll(
              elements.map((methodElement) {
                final httpMethodAnnotation =
                    _httpMethodType.firstAnnotationOfExact(methodElement);
                final httpCodeAnnotation =
                    _httpCodeType.firstAnnotationOfExact(methodElement);
                final path =
                    '$controllerPath${httpMethodAnnotation?.getField('path')?.toStringValue() ?? ''}';
                final bindMethod =
                    httpMethodAnnotation?.getField('method')?.toStringValue() ??
                        '';

                final httpCode =
                    httpCodeAnnotation?.getField('code')?.toIntValue();

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
                      CodeExpression(Code(param.type.getDisplayString(
                        withNullability: false,
                      )))
                    ],
                    {
                      'defaultValue': literal(param.defaultValueCode),
                    },
                  ));
                }

                return refer(_routesVariableName).property('add').call([
                  refer((ControllerRoute).toString()).newInstance([
                    literalString(bindMethod),
                    literalString(path),
                    refer(methodElement.name),
                    literalList(arguments),
                  ], {
                    'httpCode': literal(httpCode),
                  })
                ]).statement;
              }),
            )
            ..addExpression(refer(_routesVariableName).returned),
        ),
    );
    return Extension((extensionBuilder) => extensionBuilder
      ..name = '${element.name}Routes'
      ..on = refer(element.name)
      ..methods.add(method)).accept(DartEmitter()).toString();
  }

  List<ExecutableElement> findBindElements(ClassElement classElement) => [
        ...classElement.methods.where(_httpMethodType.hasAnnotationOf),
        ...classElement.accessors.where(_httpMethodType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
