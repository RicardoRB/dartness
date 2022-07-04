import 'package:shelf/shelf.dart';

/// DartnessInterceptor is an interface in order to handle the request before it is executed
/// this can be helpful if you want to log the request or do something else before the request is executed.
abstract class DartnessMiddleware {
  /// This method is called before the request is executed.
  void call(final Request request);
}
