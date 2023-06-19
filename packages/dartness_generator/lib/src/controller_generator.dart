import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/route.dart';
import 'package:source_gen/source_gen.dart';

class ControllerGenerator extends GeneratorForAnnotation<Controller> {
  static final _routesVariableName = 'routes';
  static final _classReturn = (List<ControllerRoute>).toString();
  static final _queryParamType = TypeChecker.fromRuntime(QueryParam);
  static final _pathParamType = TypeChecker.fromRuntime(PathParam);
  static final _bodyType = TypeChecker.fromRuntime(Body);
  static final _bindType = TypeChecker.fromRuntime(Bind);
  static final _httpCodeType = TypeChecker.fromRuntime(HttpCode);
  static final _headerType = TypeChecker.fromRuntime(Header);
  static final _headersType = TypeChecker.fromRuntime(Headers);

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

    final extension = Extension((extensionBuilder) => extensionBuilder
      ..name = '${element.name}Routes'
      ..on = refer(element.name)
      ..methods.add(method));

    final className = element.name.contains('Controller')
        ? element.name.replaceAll('Controller', 'DartnessController')
        : '${element.name}DartnessController';

    final dartnessController = Class(
      (extensionBuilder) => extensionBuilder
        ..name = className
        ..constructors.add(Constructor(
          (constructorBuilder) => constructorBuilder
            ..initializers.add(refer('super').call(
                [refer('controller'), refer('controller.getRoutes()')]).code)
            ..requiredParameters.add(Parameter(
              (parameterBuilder) => parameterBuilder
                ..name = 'controller'
                ..type = refer(element.name),
            )),
        ))
        ..extend = refer((DartnessController).toString()),
    );

    return Library((b) => b.body.addAll([extension, dartnessController]))
        .accept(DartEmitter())
        .toString();
  }

  Expression _methodElementToMethodRefer(
    final ExecutableElement methodElement,
    final ClassElement element,
    final String controllerPath,
  ) {
    final bindAnnotation = _bindType.firstAnnotationOf(methodElement);
    final httpCodeAnnotation =
        _httpCodeType.firstAnnotationOfExact(methodElement) ??
            _httpCodeType.firstAnnotationOfExact(element);
    final path =
        '$controllerPath${bindAnnotation?.getField('(super)')?.getField('path')?.toStringValue() ?? ''}';
    final bindMethod = bindAnnotation
            ?.getField('(super)')
            ?.getField('method')
            ?.toStringValue() ??
        '';

    final httpCode = httpCodeAnnotation?.getField('code')?.toIntValue();

    // Add headers
    final Map<String, String> headers = _findHeadersByAnnotations(
      methodElement,
      element,
    );

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

  /// Find the headers given a [ExecutableElement] as method element and
  /// a [ClassElement] in order to transform the annotations [Header] and [Headers]
  /// to the corresponding header for shelf
  Map<String, String> _findHeadersByAnnotations(
    final ExecutableElement methodElement,
    final ClassElement element,
  ) {
    final methodHeaderAnnotation =
        _headerType.annotationsOfExact(methodElement);
    final controllerHeaderAnnotation = _headerType.annotationsOfExact(element);
    final methodHeadersAnnotation =
        _headersType.annotationsOfExact(methodElement);
    final controllerHeadersAnnotation =
        _headersType.annotationsOfExact(element);
    final Map<String, String> headers = <String, String>{};

    // Add headers by @Header
    // Method level
    for (final methodHeader in methodHeaderAnnotation) {
      final key = methodHeader.getField('key')?.toStringValue() ?? '';
      final value = methodHeader.getField('value')?.toStringValue() ?? '';
      headers[key] = value;
    }

    //Controller level
    for (final controllerHeader in controllerHeaderAnnotation) {
      final key = controllerHeader.getField('key')?.toStringValue() ?? '';
      final value = controllerHeader.getField('value')?.toStringValue() ?? '';
      headers[key] = value;
    }

    // Add headers by @Headers
    // Method level
    for (final methodHeader in methodHeadersAnnotation) {
      final values = methodHeader.getField('values')?.toMapValue() ?? {};
      values.forEach((key, value) {
        if (key != null && key.isNull == false) {
          headers[key.toStringValue()!] = value?.toStringValue() ?? '';
        }
      });
    }

    //Controller level
    for (final controllerHeader in controllerHeadersAnnotation) {
      final values = controllerHeader.getField('values')?.toMapValue() ?? {};
      values.forEach((key, value) {
        if (key != null && key.isNull == false) {
          headers[key.toStringValue()!] = value?.toStringValue() ?? '';
        }
      });
    }
    return headers;
  }

  Expression _paramElementToParamRef(final ParameterElement param) {
    final isQuery = _queryParamType.hasAnnotationOfExact(param);
    bool isPath = _pathParamType.hasAnnotationOfExact(param);
    final isBody = _bodyType.hasAnnotationOfExact(param);
    if (isQuery && isPath) {
      throw InvalidGenerationSourceError(
          'Param `${param.name}` cannot be both @QueryParam and @PathParam');
    }
    if (isBody && isPath) {
      throw InvalidGenerationSourceError(
          'Param `${param.name}` cannot be both @Body and @PathParam');
    }
    if (isBody && isQuery) {
      throw InvalidGenerationSourceError(
          'Param `${param.name}` cannot be both @Body and @QueryParam');
    }

    if (!isQuery && !isPath && !isBody) {
      isPath = true;
    }

    final String name;
    if (isQuery) {
      final queryParamAnnotation =
          _queryParamType.firstAnnotationOfExact(param);
      name =
          queryParamAnnotation?.getField('name')?.toStringValue() ?? param.name;
    } else if (isPath) {
      final pathParamAnnotation = _pathParamType.firstAnnotationOfExact(param);
      name =
          pathParamAnnotation?.getField('name')?.toStringValue() ?? param.name;
    } else {
      name = param.name;
    }
    return refer((DartnessParam).toString()).newInstance(
      [
        literalString(name),
        literalBool(isQuery),
        literalBool(isPath),
        literalBool(isBody),
        literalBool(param.isNamed),
        literalBool(param.isPositional),
        literalBool(param.isOptional),
        CodeExpression(Code(param.type.getDisplayString(
          withNullability: false,
        ))),
      ],
      {
        'defaultValue': literal(param.defaultValueCode),
        'fromJson': isBody
            ? refer(param.type.getDisplayString(
                withNullability: false,
              )).property('fromJson')
            : literalNull,
      },
    );
  }

  List<ExecutableElement> _findBindElements(ClassElement classElement) => [
        ...classElement.methods.where(_bindType.hasAnnotationOf),
        ...classElement.accessors.where(_bindType.hasAnnotationOf)
      ]..sort((a, b) => (a.nameOffset).compareTo(b.nameOffset));
}
