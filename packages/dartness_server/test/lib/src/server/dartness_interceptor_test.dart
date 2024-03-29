import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/server.dart';
import 'package:test/test.dart';

import 'test_controller.dart';

void main() {
  late DartnessServer dartness;

  const int port = 1265;
  late HttpClient httpClient;

  setUp(() async {
    final controllers = [
      TestDartnessController(TestController.instance),
    ];

    final interceptors = [
      TestInterceptor(),
    ];
    TestInterceptor.isOnErrorCalled = false;
    TestInterceptor.isOnRequestCalled = false;
    TestInterceptor.isOnResponseCalled = false;
    httpClient = HttpClient();

    dartness = await Dartness().create(
      controllers: controllers,
      interceptors: interceptors,
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
