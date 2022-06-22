import 'dart:async';

import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/get.dart';
import 'package:dartness/bind/annotation/request_param.dart';

@Controller("/example")
class ExampleController {
  @Get()
  static String getEmpty() {
    return "Empty";
  }

  @Get("/double")
  static double getDouble() {
    return 1.1;
  }

  @Get("/null")
  static dynamic getNull() {
    return null;
  }

  @Get("/class")
  static Foo getClass() {
    return Foo('class');
  }

  @Get("/future")
  static Future<String> getFuture() async {
    return Future.value("bla");
  }

  @Get("/<id>")
  static int getParam(int pathParam) {
    return pathParam;
  }
}

class Foo {
  const Foo(this.value);

  final String value;

  Map<dynamic, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}
