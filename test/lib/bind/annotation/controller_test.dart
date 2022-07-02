import 'dart:convert';
import 'dart:io';

import 'package:dartness/bind/annotation/body.dart';
import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/delete.dart';
import 'package:dartness/bind/annotation/get.dart';
import 'package:dartness/bind/annotation/http_status.dart';
import 'package:dartness/bind/annotation/path_param.dart';
import 'package:dartness/bind/annotation/post.dart';
import 'package:dartness/bind/annotation/put.dart';
import 'package:dartness/bind/annotation/query_param.dart';
import 'package:dartness/dartness.dart';
import 'package:test/test.dart';

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
      dartness = Dartness(
        port: port,
      );
      dartness.addController(ControllerClass());
      dartness.addController(GetControllerClass());
      dartness.addController(PostControllerClass());
      dartness.addController(PutControllerClass());
      dartness.addController(DeleteControllerClass());
      await dartness.create();
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

      test(
        'GET query params with multiple',
        () async {
          final request = await httpClient.get(
              'localhost', port, '/get/queries?id=1&id2=2');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          expect(
              await response.transform(utf8.decoder).join(), equals('"1/2"'));
        },
      );

      test(
        'GET query params with path params',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/paths/1?query=2');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          expect(
              await response.transform(utf8.decoder).join(), equals('"1/2"'));
        },
      );

      test(
        'GET query params with path params and multiple',
        () async {
          final request = await httpClient.get(
              'localhost', port, '/get/paths/1/another/2?query=3&query2=4');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          expect(await response.transform(utf8.decoder).join(),
              equals('"1/2/3/4"'));
        },
      );

      test(
        'GET query params with every object type',
        () async {
          final request = await httpClient.get(
            'localhost',
            port,
            '/get/types?int=3'
                '&string="hi"'
                '&double=4.4'
                '&bool=true'
                '&list=[1,2]',
          );
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          expect(await response.transform(utf8.decoder).join(),
              equals('"true/3/4.4/\\"hi\\"/[1, 2]"'));
        },
      );

      test(
        'GET query name and param name',
        () async {
          final request = await httpClient.get(
              'localhost', port, '/get/names/params?nameQuery=testName');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          expect(await response.transform(utf8.decoder).join(),
              equals('"params/testName"'));
        },
      );

      test(
        'GET with response status code 202',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/statuscodes');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.accepted);
          expect(await response.transform(utf8.decoder).join(), isEmpty);
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

      test('POST body', () async {
        final request = await httpClient.post('localhost', port, '/post/body');
        request.headers
            .set(HttpHeaders.contentTypeHeader, ContentType.json.mimeType);
        request.write('{"value":"foo"}');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        expect(await response.transform(utf8.decoder).join(),
            equals('{"value":"foo"}'));
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
  static int getParam(@PathParam() int id) {
    return id;
  }

  @Get("/query")
  static int getQuery(@QueryParam() int id) {
    return id;
  }

  @Get("/queries")
  static String getQueries(
    @QueryParam() int id,
    @QueryParam() int id2,
  ) {
    return '$id/$id2';
  }

  @Get("/paths/<id>")
  static String getPaths(
    @PathParam() int id,
    @QueryParam() int query,
  ) {
    return '$id/$query';
  }

  @Get("/paths/<path1>/another/<path2>")
  static String getPathsAnotherPaths(
    @PathParam() int path1,
    @QueryParam() int query,
    @PathParam() int path2,
    @QueryParam() int query2,
  ) {
    return '$path1/$path2/$query/$query2';
  }

  @Get("/types")
  static String getTypes(
    @QueryParam() bool bool,
    @QueryParam() int int,
    @QueryParam() double double,
    @QueryParam() String string,
    @QueryParam() List<int> list,
  ) {
    return '$bool/$int/$double/$string/$list';
  }

  @Get("/names/<namePath>")
  static String getNames(
    @PathParam("namePath") String otherPath,
    @QueryParam("nameQuery") String otherQuery,
  ) {
    return '$otherPath/$otherQuery';
  }

  @HttpCode(HttpStatus.accepted)
  @Get("/statuscodes")
  static getStatusCode() {}
}

@Controller("/post")
class PostControllerClass {
  @Post("/double")
  static double postDouble() {
    return 1.1;
  }

  @Post("/null")
  static dynamic postNull() {
    return null;
  }

  @Post("/class")
  static Foo postClass() {
    return Foo('class');
  }

  @Post("/future")
  static Future<String> postFuture() async {
    return Future.value("bla");
  }

  @Post("/ids/<id>")
  static int postParam(@PathParam() int id) {
    return id;
  }

  @Post("/body")
  static Foo postBody(@Body() Foo body) {
    return body;
  }
}

@Controller("/put")
class PutControllerClass {
  @Put("/double")
  static double putDouble() {
    return 1.1;
  }

  @Put("/null")
  static dynamic putNull() {
    return null;
  }

  @Put("/class")
  static Foo putClass() {
    return Foo('class');
  }

  @Put("/future")
  static Future<String> putFuture() async {
    return Future.value("bla");
  }

  @Put("/ids/<id>")
  static int putParam(@PathParam() int id) {
    return id;
  }
}

@Controller("/delete")
class DeleteControllerClass {
  @Delete("/double")
  static double deleteDouble() {
    return 1.1;
  }

  @Delete("/null")
  static dynamic deleteNull() {
    return null;
  }

  @Delete("/class")
  static Foo deleteClass() {
    return Foo('class');
  }

  @Delete("/future")
  static Future<String> deleteFuture() async {
    return Future.value("bla");
  }

  @Delete("/ids/<id>")
  static int deleteParam(int id) {
    return id;
  }
}

class Foo {
  const Foo(this.value);

  final String value;

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }

  Foo.fromJson(Map<String, dynamic> json) : value = json['value'];
}
