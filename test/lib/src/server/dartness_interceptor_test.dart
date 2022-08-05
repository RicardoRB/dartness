import 'dart:io';

import 'package:dartness_server/bind.dart';
import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:dartness_server/src/dartness.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Dartness dartness;

  const int port = 1453;
  late HttpClient httpClient;

  setUp(() async {
    TestInterceptor.isOnErrorCalled = false;
    TestInterceptor.isOnRequestCalled = false;
    TestInterceptor.isOnResponseCalled = false;
    httpClient = HttpClient();
    dartness = Dartness(
      port: port,
      controllers: [TestController()],
      interceptors: [TestInterceptor()],
    );
    await dartness.create();
  });

  tearDown(() async {
    await dartness.close();
  });

  test(
      ""
      "GIVEN a interceptor "
      "WHEN sending a request to the server"
      "THEN onRequest and onResponse is called"
      "", () async {
    final request = await httpClient.get('localhost', port, '/auth');
    await request.close();

    expect(TestInterceptor.isOnRequestCalled, isTrue);
    expect(TestInterceptor.isOnResponseCalled, isTrue);
    expect(TestInterceptor.isOnErrorCalled, isFalse);
  });

  test(
      ""
      "GIVEN a interceptor "
      "WHEN sending a request to the server"
      "AND a exception is thrown"
      "THEN onRequest and onError is called"
      "", () async {
    final request = await httpClient.get('localhost', port, '/auth/error');
    await request.close();

    expect(TestInterceptor.isOnRequestCalled, isTrue);
    expect(TestInterceptor.isOnResponseCalled, isFalse);
    expect(TestInterceptor.isOnErrorCalled, isTrue);
  });
}

@Controller("/auth")
class TestController {
  @Get()
  static String get() => '';

  @Get("/error")
  static String getError() => throw Exception("random exception");
}

class TestInterceptor implements DartnessInterceptor {
  static bool isOnRequestCalled = false;
  static bool isOnResponseCalled = false;
  static bool isOnErrorCalled = false;

  @override
  void onError(Object error, StackTrace stackTrace) {
    TestInterceptor.isOnErrorCalled = true;
  }

  @override
  void onRequest(Request request) {
    TestInterceptor.isOnRequestCalled = true;
  }

  @override
  void onResponse(Response response) {
    TestInterceptor.isOnResponseCalled = true;
  }
}
