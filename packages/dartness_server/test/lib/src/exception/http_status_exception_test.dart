import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

void main() {
  group('http tests', () {
    late DartnessServer dartness;

    const int port = 2314;
    late HttpClient httpClient;

    setUp(() async {
      httpClient = HttpClient();
      dartness = await Dartness().create(
        // AppModule(
        //   metadata: ModuleMetadata(),
        // ),
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
            await httpClient.get('localhost', port, '/get/custom_exception');
        final response = await request.close();
        expect(response.statusCode, HttpStatus.notFound);
      },
    );
  });
}
