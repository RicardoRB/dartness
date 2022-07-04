import 'package:logger/logger.dart';
import 'package:shelf/shelf.dart';

import 'dartness_interceptor.dart';

/// Middleware which prints the time of the request, the elapsed time for the
/// inner handlers, the response's status code and the request URI.
class LogRequestsInterceptor implements DartnessInterceptor {
  late DateTime startTime;
  late Stopwatch watch;
  late Uri uri;
  late String method;
  final Logger _logger = Logger();

  @override
  void onRequest(Request request) {
    startTime = DateTime.now();
    watch = Stopwatch()..start();
    uri = request.requestedUri;
    method = request.method;
    final msg = _message(startTime, request.requestedUri, request.method);
    _logger.i(msg);
  }

  @override
  void onResponse(Response response) {
    final msg = _messageResponse(
        startTime, response.statusCode, uri, method, watch.elapsed);
    _logger.i(msg);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    final msg = _messageError(startTime, uri, method, watch.elapsed);
    _logger.e("Error request $msg", error, stackTrace);
  }

  String _message(
    final DateTime requestTime,
    final Uri requestedUri,
    final String method,
  ) {
    return '${requestTime.toIso8601String()} '
        '${method.padRight(7)} ' // 7 - longest standard HTTP method
        '${requestedUri.path}${_formatQuery(requestedUri.query)}';
  }

  String _messageResponse(
    DateTime requestTime,
    int statusCode,
    Uri requestedUri,
    String method,
    Duration elapsedTime,
  ) {
    return '${requestTime.toIso8601String()} '
        '${elapsedTime.toString().padLeft(15)} '
        '${method.padRight(7)} [$statusCode] ' // 7 - longest standard HTTP method
        '${requestedUri.path}${_formatQuery(requestedUri.query)}';
  }

  String _formatQuery(final String query) {
    return query == '' ? '' : '?$query';
  }

  String _messageError(
    DateTime requestTime,
    Uri requestedUri,
    String method,
    Duration elapsedTime,
  ) {
    return '${requestTime.toIso8601String()} '
        '${elapsedTime.toString().padLeft(15)} '
        '${method.padRight(7)} ' // 7 - longest standard HTTP method
        '${requestedUri.path}${_formatQuery(requestedUri.query)}';
  }
}
