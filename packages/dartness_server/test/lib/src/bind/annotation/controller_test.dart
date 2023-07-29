import 'dart:convert';
import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/route.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

import 'class_controller.dart';
import 'delete_controller_class.dart';
import 'get_controller_class.dart';
import 'post_controller_class.dart';
import 'put_controller_class.dart';

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
    late DartnessServer dartness;

    const int port = 1432;
    late HttpClient httpClient;

    setUp(() async {
      final controllers = [
        ClassDartnessController(ClassController.instance),
        GetDartnessControllerClass(GetControllerClass.instance),
        PostDartnessControllerClass(PostControllerClass.instance),
        PutDartnessControllerClass(PutControllerClass.instance),
        DeleteDartnessControllerClass(DeleteControllerClass.instance),
      ];

      httpClient = HttpClient();
      dartness = await Dartness().create(
        // AppModule(
        //   metadata: ModuleMetadata(
        //     controllers: controllers,
        //   ),
        // ),
        options: DartnessApplicationOptions(
          port: port,
        ),
      );
    });

    tearDown(() async {
      await dartness.stop();
    });

    group('GET method tests', () {
      test(
          'GIVEN a controller with GET method '
          'WHEN calling "/"'
          'THEN return "Empty"', () async {
        final request = await httpClient.get('localhost', port, '/');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals("Empty"));
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
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('1.1'));
      });

      test('GET null', () async {
        final request = await httpClient.get('localhost', port, '/get/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals(''));
      });

      test('GET class', () async {
        final request = await httpClient.get('localhost', port, '/get/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('{"value":"class"}'));
      });

      test('GET future', () async {
        final request = await httpClient.get('localhost', port, '/get/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('bla'));
      });

      test('GET param', () async {
        final request = await httpClient.get('localhost', port, '/get/ids/1');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('1'));
      });

      test(
        'GET query params',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/query?id=1');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('1'));
        },
      );

      test(
        'GET query params with multiple',
        () async {
          final request = await httpClient.get(
              'localhost', port, '/get/queries?id=1&id2=2');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('1/2'));
        },
      );

      test(
        'GET query params with path params',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/paths/1?query=2');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('1/2'));
        },
      );

      test(
        'GET query params with path params and multiple',
        () async {
          final request = await httpClient.get(
              'localhost', port, '/get/paths/1/another/2?query=3&query2=4');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('1/2/3/4'));
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
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('true/3/4.4/"hi"/[1, 2]'));
        },
      );

      test(
        'GET query params with optionals values',
        () async {
          final request = await httpClient.get(
            'localhost',
            port,
            '/get/optional?int=3&bool=true',
          );
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('true/3'));
        },
      );

      test(
        'GET query params with optionals values sending none',
        () async {
          final request = await httpClient.get(
            'localhost',
            port,
            '/get/optional',
          );
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('null/1'));
        },
      );

      test(
        'GET query name and param name',
        () async {
          final request = await httpClient.get(
              'localhost', port, '/get/names/params?nameQuery=testName');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          final body = await response.transform(utf8.decoder).join();
          expect(body, equals('params/testName'));
        },
      );

      test(
        'GET with response status code 202',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/statuscodes');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.accepted);
          final body = await response.transform(utf8.decoder).join();
          expect(body, isEmpty);
        },
      );

      test(
        'GET with response header test : test',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/headers');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.ok);
          bool containsHeader = false;
          response.headers.forEach((name, values) {
            if (name == 'test') {
              containsHeader = values.contains('test');
            }
          });
          expect(containsHeader, isTrue);
        },
      );

      test(
        'GET with custom http status exception',
        () async {
          final request =
              await httpClient.get('localhost', port, '/get/custom_exception');
          final response = await request.close();
          expect(response.statusCode, HttpStatus.notFound);
          // expect(response, isTrue);
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
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('Empty'));
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
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('1.1'));
      });

      test('POST null', () async {
        final request = await httpClient.post('localhost', port, '/post/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals(''));
      });

      test('POST class', () async {
        final request = await httpClient.post('localhost', port, '/post/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('{"value":"class"}'));
      });

      test('POST future', () async {
        final request =
            await httpClient.post('localhost', port, '/post/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('bla'));
      });

      test('POST param', () async {
        final request = await httpClient.post('localhost', port, '/post/ids/1');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('1'));
      });

      test('POST body', () async {
        final request = await httpClient.post('localhost', port, '/post/body');
        request.headers
            .set(HttpHeaders.contentTypeHeader, ContentType.json.mimeType);
        request.write('{"value":"foo"}');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('{"value":"foo"}'));
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
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('1.1'));
      });

      test('PUT null', () async {
        final request = await httpClient.put('localhost', port, '/put/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals(''));
      });

      test('PUT class', () async {
        final request = await httpClient.put('localhost', port, '/put/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('{"value":"class"}'));
      });

      test('PUT future', () async {
        final request = await httpClient.put('localhost', port, '/put/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('bla'));
      });

      test('PUT param', () async {
        final request = await httpClient.put('localhost', port, '/put/ids/1');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('1'));
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
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('1.1'));
      });

      test('DELETE null', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/null');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals(''));
      });

      test('DELETE class', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/class');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('{"value":"class"}'));
      });

      test('DELETE future', () async {
        final request =
            await httpClient.delete('localhost', port, '/delete/future');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
        final body = await response.transform(utf8.decoder).join();
        expect(body, equals('bla'));
      });
    });
  });
}
