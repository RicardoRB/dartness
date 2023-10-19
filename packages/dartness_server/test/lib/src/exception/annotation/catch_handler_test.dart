import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

import 'custom_error_handler.dart';
import 'get_controller_class.dart';

void main() {
  group('http tests', () {
    late DartnessServer dartness;

    const int port = 8434;
    late HttpClient httpClient;

    setUp(() async {
      final controllers = [
        GetDartnessControllerClass(GetControllerClass.instance),
      ];

      final errorHandlers = [
        CustomDartnessErrorHandler(CustomErrorHandler.instance)
      ];
      httpClient = HttpClient();

      dartness = await Dartness().create(
        controllers: controllers,
        errorHandlers: errorHandlers,
        options: DartnessApplicationOptions(
          port: port,
        ),
      );
    });

    tearDown(() async {
      await dartness.stop();
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
