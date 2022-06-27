import 'dart:convert';
import 'dart:io';

import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/delete.dart';
import 'package:dartness/bind/annotation/get.dart';
import 'package:dartness/bind/annotation/post.dart';
import 'package:dartness/bind/annotation/put.dart';
import 'package:dartness/bind/annotation/query_param.dart';
import 'package:test/test.dart';

import '../../../../bin/dartness.dart';

void main() {
  late Controller controller;

  group('path tests', () {
    test('path empty', () {
      controller = Controller("");
      expect(controller.path, "");
    });

    test('path with slash', () {
      controller = Controller("/");
      expect(controller.path, "/");
    });

    test('path with slash and param', () {
      controller = Controller("/<id>");
      expect(controller.path, "/<id>");
    });

    test('path with slash and param and slash', () {
      controller = Controller("/<id>/");
      expect(controller.path, "/<id>/");
    });

    test('path with slash and param and slash and param', () {
      controller = Controller("/<id>/<id>");
      expect(controller.path, "/<id>/<id>");
    });

    test('path with slash and param and slash and param and slash', () {
      controller = Controller("/<id>/<id>/");
      expect(controller.path, "/<id>/<id>/");
    });
  });

  group('http tests', () {
    late Dartness dartness;

    const int port = 1243;
    late HttpClient httpClient;

    setUp(() async {
      httpClient = HttpClient();
      dartness = Dartness();
      dartness.addController(ControllerClass());
      dartness.addController(GetControllerClass());
      dartness.addController(PostControllerClass());
      dartness.addController(PutControllerClass());
      dartness.addController(DeleteControllerClass());
      await dartness.create(
        port: port,
      );
    });

    tearDown(() async {
      await dartness.close();
    });

    group('GET method tests', () {
      test(
          'GIVEN a controller with GET method '
          'WHEN calling "/"'
          'THEN return "Empty"', () async {
        final request = await httpClient.get('localhost', port, '/');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(
            await response.transform(utf8.decoder).join(), equals('"Empty"'));
      });

      test('GET not found', () async {
        final request =
            await httpClient.get('localhost', port, '/get/notfound');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.notFound);
      });

      test('GET double', () async {
        final request = await httpClient.get('localhost', port, '/get/double');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('1.1'));
      });

      test('GET null', () async {
        final request = await httpClient.get('localhost', port, '/get/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals(''));
      });

      test('GET class', () async {
        final request = await httpClient.get('localhost', port, '/get/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(),
            equals('{"value":"class"}'));
      });

      test('GET future', () async {
        final request = await httpClient.get('localhost', port, '/get/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('bla'));
      });

      test('GET param', () async {
        final request = await httpClient.get('localhost', port, '/get/ids/1');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('1'));
      });

      test(
        'GET query params',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/query?id=1');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          expect(await response.transform(utf8.decoder).join(), equals('1'));
        },
      );
    });

    group('POST method tests', () {
      test(
          'GIVEN a controller with POST method '
          'WHEN calling "/" '
          'THEN return "Empty"', () async {
        final request = await httpClient.post('localhost', port, '/');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(
            await response.transform(utf8.decoder).join(), equals('"Empty"'));
      });

      test('POST not found', () async {
        final request =
            await httpClient.post('localhost', port, '/post/notfound');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.notFound);
      });

      test('POST double', () async {
        final request =
            await httpClient.post('localhost', port, '/post/double');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('1.1'));
      });

      test('POST null', () async {
        final request = await httpClient.post('localhost', port, '/post/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals(''));
      });

      test('POST class', () async {
        final request = await httpClient.post('localhost', port, '/post/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(),
            equals('{"value":"class"}'));
      });

      test('POST future', () async {
        final request =
            await httpClient.post('localhost', port, '/post/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('bla'));
      });

      test('POST param', () async {
        final request = await httpClient.post('localhost', port, '/post/ids/1');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('1'));
      });
    });

    group('PUT method tests', () {
      test(
          'GIVEN a controller with PUT method '
          'WHEN calling "/"'
          'THEN return "Empty"', () async {
        final request = await httpClient.put('localhost', port, '/');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
      });

      test('PUT not found', () async {
        final request =
            await httpClient.put('localhost', port, '/put/notfound');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.notFound);
      });

      test('PUT double', () async {
        final request = await httpClient.put('localhost', port, '/put/double');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('1.1'));
      });

      test('PUT null', () async {
        final request = await httpClient.put('localhost', port, '/put/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals(''));
      });

      test('PUT class', () async {
        final request = await httpClient.put('localhost', port, '/put/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(),
            equals('{"value":"class"}'));
      });

      test('PUT future', () async {
        final request = await httpClient.put('localhost', port, '/put/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('bla'));
      });

      test('PUT param', () async {
        final request = await httpClient.put('localhost', port, '/put/ids/1');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('1'));
      });
    });

    group('DELETE method tests', () {
      test(
          'GIVEN a controller with DELETE method '
          'WHEN calling "/"'
          'THEN return "Empty"', () async {
        final request = await httpClient.delete('localhost', port, '/');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
      });

      test('DELETE not found', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/notfound');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.notFound);
      });

      test('DELETE double', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/double');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('1.1'));
      });

      test('DELETE null', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals(''));
      });

      test('DELETE class', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(),
            equals('{"value":"class"}'));
      });

      test('DELETE future', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(), equals('bla'));
      });
    });
  });
}

@Controller("/")
class ControllerClass {
  @Get()
  static String getEmpty() {
    return "Empty";
  }

  @Post()
  static String postEmpty() {
    return "Empty";
  }

  @Put()
  static String putEmpty() {
    return "Empty";
  }

  @Delete()
  static String deleteEmpty() {
    return "Empty";
  }
}

@Controller("/get")
class GetControllerClass {
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
    return id;
  }

  @Get("/query")
  static int getQuery(@QueryParam() int id) {
    return id;
  }

}

@Controller("/post")
class PostControllerClass {
  @Post("/double")
  static double getDouble() {
    return 1.1;
  }

  @Post("/null")
  static dynamic getNull() {
    return null;
  }

  @Post("/class")
  static Foo getClass() {
    return Foo('class');
  }

  @Post("/future")
  static Future<String> getFuture() async {
    return Future.value("bla");
  }

  @Post("/ids/<id>")
  static int getParam(int id) {
    return id;
  }
}

@Controller("/put")
class PutControllerClass {
  @Put("/double")
  static double getDouble() {
    return 1.1;
  }

  @Put("/null")
  static dynamic getNull() {
    return null;
  }

  @Put("/class")
  static Foo getClass() {
    return Foo('class');
  }

  @Put("/future")
  static Future<String> getFuture() async {
    return Future.value("bla");
  }

  @Put("/ids/<id>")
  static int getParam(int id) {
    return id;
  }
}

@Controller("/delete")
class DeleteControllerClass {
  @Delete("/double")
  static double getDouble() {
    return 1.1;
  }

  @Delete("/null")
  static dynamic getNull() {
    return null;
  }

  @Delete("/class")
  static Foo getClass() {
    return Foo('class');
  }

  @Delete("/future")
  static Future<String> getFuture() async {
    return Future.value("bla");
  }

  @Delete("/ids/<id>")
  static int getParam(int id) {
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
