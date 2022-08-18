import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

void main() {
  late Dartness dartness;

  const int port = 1243;
  late HttpClient httpClient;

  setUp(() async {
    httpClient = HttpClient();
    dartness = Dartness(
      port: port,
      // controllers: [TestController()],
      middlewares: [TestMiddleware()],
    );
    await dartness.create();
  });

  tearDown(() async {
    await dartness.close();
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

@Controller("/auth")
class TestController {
  @Get()
  static String get() => '';
}

class TestMiddleware implements DartnessMiddleware {
  @override
  void handle(DartnessRequest request) {
    if (!request.headers.containsKey(HttpHeaders.authorizationHeader)) {
      throw HttpException("Unauthorized", uri: request.requestedUri);
    }
  }
}
