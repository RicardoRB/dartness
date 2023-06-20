import 'package:dartness_server/server.dart';

class ExampleInterceptor implements DartnessInterceptor {
  @override
  void onError(Object error, StackTrace stackTrace) {
    print('onError: $error');
  }

  @override
  void onRequest(DartnessRequest request) {
    print('onRequest: ${request.method}');
  }

  @override
  void onResponse(DartnessResponse response) {
    print('onResponse: ${response.statusCode}');
  }
}
