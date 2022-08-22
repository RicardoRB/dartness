import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:test/test.dart';

import 'get_controller_class.dart';

void main() {
  group('http tests', () {
    late Dartness dartness;

    const int port = 2314;
    late HttpClient httpClient;

    setUp(() async {
      httpClient = HttpClient();
      dartness = Dartness(
        port: port,
      );
      dartness.addController(
          GetDartnessControllerClass(GetControllerClass.instance));
      await dartness.create();
    });

    tearDown(() async {
      await dartness.close();
    });

    test(
      'GET with custom http status exception',
      () async {
        final request =
            await httpClient.get('localhost', port, '/get/custom_exception');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.notFound);
      },
    );
  });
}
