import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartness_server/bind.dart';
import 'package:source_gen/source_gen.dart';

class DartnessGenerator extends GeneratorForAnnotation<Controller> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return "// Hello word!";
  }
}
