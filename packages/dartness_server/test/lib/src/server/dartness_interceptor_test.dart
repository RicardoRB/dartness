import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

import 'test_controller.dart';

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
      controllers: [
        TestDartnessController(TestController.instance),
      ],
      interceptors: [
        TestInterceptor(),
      ],
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

class TestInterceptor implements DartnessInterceptor {
  static bool isOnRequestCalled = false;
  static bool isOnResponseCalled = false;
  static bool isOnErrorCalled = false;

  @override
  void onError(Object error, StackTrace stackTrace) {
    TestInterceptor.isOnErrorCalled = true;
  }

  @override
  void onRequest(DartnessRequest request) {
    TestInterceptor.isOnRequestCalled = true;
  }

  @override
  void onResponse(DartnessResponse response) {
    TestInterceptor.isOnResponseCalled = true;
  }
}
