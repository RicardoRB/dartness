import 'dart:convert';
import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

import 'test_controller.dart';

void main() {
  late DartnessServer dartness;

  const int port = 1243;
  late HttpClient httpClient;

  setUp(() async {
    final controllers = [
      TestDartnessController(TestController.instance),
    ];
    httpClient = HttpClient();
    dartness = await Dartness().create(
      controllers: controllers,
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
      "GIVEN a path that do not exists "
      "WHEN sending a request to the server "
      "THEN throw NotFound http status"
      "", () async {
    final expected = HttpStatus.notFound;
    final request = await httpClient.get('localhost', port, '/not/found/path');
    final response = await request.close();

    final body = await response.transform(utf8.decoder).join();
    print(body);

    /// The response should be a 404 NotFound
    /// this must be fixed in the future with the exception handler
    expect(response.statusCode, expected);
  });
}
