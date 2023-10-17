import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

import 'test_controller.dart';
import 'test_middleware.dart';

void main() {
  late DartnessServer dartness;

  const int port = 1243;
  late HttpClient httpClient;

  setUp(() async {
    final controllers = [
      TestDartnessController(TestController.instance),
    ];

    final middlewares = [
      TestMiddleware(),
    ];
    httpClient = HttpClient();
    dartness = await Dartness().create(
      controllers: controllers,
      middlewares: middlewares,
      options: DartnessApplicationOptions(
        port: port,
      ),
    );
  });

  tearDown(() async {
    await dartness.stop();
  });

  test(
      ""
      "GIVEN a Middleware that handles the request before the request is executed"
      "in order to validate the authentication of the request"
      "WHEN sending a request to the server"
      "THEN throw HttpException"
      "", () async {
    final expected = HttpStatus.internalServerError;
    final request = await httpClient.get('localhost', port, '/auth');
    final response = await request.close();

    /// The response should be a 401 Unauthorized
    /// this must be fixed in the future with the exception handler
    expect(response.statusCode, expected);
  });
}
