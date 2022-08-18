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
  static final _bindType = TypeChecker.fromRuntime(Bind);
  static final _httpCodeType = TypeChecker.fromRuntime(HttpCode);
  static final _headerType = TypeChecker.fromRuntime(Header);

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
    final elements = _findBindElements(element);
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
                final methodRef = _methodElementToMethodRefer(
                    methodElement, element, controllerPath);
                return refer(_routesVariableName)
                    .property('add')
                    .call([methodRef]).statement;
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

  Expression _methodElementToMethodRefer(final ExecutableElement methodElement,
      final ClassElement element, final String controllerPath) {
    final bindAnnotation = _bindType.firstAnnotationOf(methodElement);
    final httpCodeAnnotation =
        _httpCodeType.firstAnnotationOfExact(methodElement) ??
            _httpCodeType.firstAnnotationOfExact(element);
    final methodHeaderAnnotation =
        _headerType.annotationsOfExact(methodElement);
    final controllerHeaderAnnotation = _headerType.annotationsOfExact(element);
    final path =
        '$controllerPath${bindAnnotation?.getField('(super)')?.getField('path')?.toStringValue() ?? ''}';
    final bindMethod = bindAnnotation
            ?.getField('(super)')
            ?.getField('method')
            ?.toStringValue() ??
        '';

    final httpCode = httpCodeAnnotation?.getField('code')?.toIntValue();

    final Map<String, String> headers = <String, String>{};

    for (final methodHeader in methodHeaderAnnotation) {
      final key = methodHeader.getField('key')?.toStringValue() ?? '';
      final value = methodHeader.getField('value')?.toStringValue() ?? '';
      headers[key] = value;
    }

    for (final controllerHeader in controllerHeaderAnnotation) {
      final key = controllerHeader.getField('key')?.toStringValue() ?? '';
      final value = controllerHeader.getField('value')?.toStringValue() ?? '';
      headers[key] = value;
    }

    final List<Expression> arguments = [];

    for (final param in methodElement.parameters) {
      final paramRefer = _paramElementToParamRef(param);
      arguments.add(paramRefer);
    }
    final methodRef = refer((ControllerRoute).toString()).newInstance([
      literalString(bindMethod),
      literalString(path),
      refer(methodElement.name),
      literalList(arguments),
    ], {
      'httpCode': literal(httpCode),
      'headers': literalMap(headers),
    });
    return methodRef;
  }

  Expression _paramElementToParamRef(final ParameterElement param) {
    final isQuery = _queryParamType.hasAnnotationOfExact(param);
    final isPath = _pathParamType.hasAnnotationOfExact(param);
    if (isQuery && isPath) {
      throw InvalidGenerationSourceError(
          'Param `${param.name}` cannot be both @QueryParam and @PathParam');
    }
    return refer((DartnessParam).toString()).newInstance(
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
    );
  }

  List<ExecutableElement> _findBindElements(ClassElement classElement) => [
        ...classElement.methods.where(_bindType.hasAnnotationOf),
        ...classElement.accessors.where(_bindType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
