import 'dart:async';

import 'package:dartness_server/http_method.dart';

import 'not_found_exception.dart';

@Controller("/example")
class ExampleController {
  @Bind.get()
  static String getEmpty() {
    return "Empty";
  }

  @Bind.get("/double")
  static double getDouble() {
    return 1.1;
  }

  @Bind.get("/null")
  static dynamic getNull() {
    return null;
  }

  @Bind.get("/class")
  static Foo getClass() {
    return Foo('class');
  }

  @Bind.get("/future")
  static Future<String> getFuture() async {
    return Future.value("bla");
  }

  @Bind.get("/ids/<id>")
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
