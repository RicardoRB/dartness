import 'package:shelf/shelf.dart';

/// DartnessInterceptor is an interface in order to handle the request before it is executed
/// and handle the response after the request is executed.
abstract class DartnessInterceptor {
  /// This method is called before the request is executed.
  void onRequest(final Request request);

  /// This method is called after the request is executed.
  void onResponse(final Response response);

  /// This method is called when an error occurs when executing the request.
  void onError(final Object error, final StackTrace stackTrace);
}
