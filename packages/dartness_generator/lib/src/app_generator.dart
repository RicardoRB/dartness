import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dartness_server/dartness.dart';
import 'package:source_gen/source_gen.dart';

const _appType = TypeChecker.fromRuntime(App);

class AppGenerator extends GeneratorForAnnotation<App> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
          '@${element.name} cannot target `${element.runtimeType}`.');
    }

    final dartnessApp = 'app';
    final classDartness = (Dartness).toString();
    final port =
        _appType.firstAnnotationOf(element)?.getField('port')?.toIntValue() ??
            3000;
    final internetAddress = _appType
        .firstAnnotationOf(element)
        ?.getField('internetAddress')
        ?.toStringValue();

    final method = Method(
      (methodBuilder) => methodBuilder
        ..name = 'create'
        ..modifier = MethodModifier.async
        // ..returns = refer(classDartness)
        ..body = Block(
          (blocBuilder) => blocBuilder
            ..addExpression(
              refer(classDartness).newInstance([], {
                'port': literalNum(port),
                'internetAddress': internetAddress == null
                    ? literalNull
                    : literalString(internetAddress),
              }).assignFinal(dartnessApp),
            )
            ..statements.add(
              refer(dartnessApp).property('create').call([]).awaited.statement,
            ),
        ),
    );

    return Extension((extensionBuilder) => extensionBuilder
      ..name = '_\$${element.name}App'
      ..on = refer(element.name)
      ..methods.add(method)).accept(DartEmitter()).toString();
  }
}
