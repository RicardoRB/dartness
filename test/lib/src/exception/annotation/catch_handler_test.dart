import 'dart:io';

import 'package:dartness_server/bind.dart';
import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/src/exception/annotation/catch_error.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('http tests', () {
    late Dartness dartness;

    const int port = 8434;
    late HttpClient httpClient;

    setUp(() async {
      httpClient = HttpClient();
      dartness = Dartness(
        port: port,
      );
      dartness.addController(GetControllerClass());
      dartness.addErrorHandler(CustomErrorHandler());
      await dartness.create();
    });

    tearDown(() async {
      await dartness.close();
    });

    test(
      'GET with custom http status exception',
      () async {
        final request =
            await httpClient.get('localhost', port, '/get/argument_error');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.badRequest);
      },
    );

    test(
      'GET with custom http status exception',
      () async {
        final request =
            await httpClient.get('localhost', port, '/get/range_error');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.internalServerError);
      },
    );
  });
}

@Controller("/get")
class GetControllerClass {
  @Get("/argument_error")
  static getArgumentException() {
    throw ArgumentError('Random exception');
  }

  @Get("/range_error")
  static getRangeError() {
    throw RangeError('Random exception');
  }
}

class CustomErrorHandler {
  @CatchError([ArgumentError])
  static Response argumentErrorHandler(ArgumentError error, Request request) {
    return Response(
      HttpStatus.badRequest,
      body: 'ArgumentError',
    );
  }

  @CatchError([RangeError])
  static void rangeErrorHandler(RangeError error, Request request) {
    print('RangeError');
  }
}
