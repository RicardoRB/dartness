import 'dart:async';

import 'package:dartness_server/bind/annotation/controller.dart';
import 'package:dartness_server/bind/annotation/get.dart';

import 'not_found_exception.dart';

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

  @Get("/ids/<id>")
  static int getParam(int id) {
    if (id < 0) {
      throw NotFoundException("Id not found");
    }
    return id;
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
