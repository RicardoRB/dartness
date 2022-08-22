import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/exception.dart';
import 'package:test/test.dart';

import 'custom_error_handler.dart';
import 'get_controller_class.dart';

void main() {
  group('http tests', () {
    late Dartness dartness;

    const int port = 8434;
    late HttpClient httpClient;

    setUp(() async {
      httpClient = HttpClient();
      dartness = Dartness(
        port: port,
        controllers: [
          DartnessController(
            GetControllerClass.instance,
            GetControllerClass.instance.getRoutes(),
          ),
        ],
        errorHandlers: [
          DartnessErrorHandler(
            CustomErrorHandler.instance,
            CustomErrorHandler.instance.getCatchErrors(),
          ),
        ],
      );
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
