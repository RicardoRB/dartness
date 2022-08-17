import 'package:dartness_server/server.dart';
import 'package:shelf/src/request.dart';
import 'package:shelf/src/response.dart';

class ExampleInterceptor implements DartnessInterceptor {
  @override
  void onError(Object error, StackTrace stackTrace) {
    print('onError: $error');
  }

  @override
  void onRequest(Request request) {
    print('onRequest: ${request.method}');
  }

  @override
  void onResponse(Response response) {
    print('onResponse: ${response.statusCode}');
  }
}
