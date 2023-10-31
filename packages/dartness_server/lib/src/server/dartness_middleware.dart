import '../provider.dart';
import 'dartness_request.dart';

/// DartnessInterceptor is an interface in order to handle the request before it is executed
/// this can be helpful if you want to log the request or do something else before the request is executed.
abstract interface class DartnessMiddleware implements Provider {
  /// This method is called before the request is executed.
  void handle(final DartnessRequest request);
}
