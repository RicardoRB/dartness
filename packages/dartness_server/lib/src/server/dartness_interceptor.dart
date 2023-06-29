import '../provider.dart';
import 'dartness_request.dart';
import 'dartness_response.dart';

/// DartnessInterceptor is an interface in order to handle the request before it is executed
/// and handle the response after the request is executed.
abstract class DartnessInterceptor implements Provider {
  /// This method is called before the request is executed.
  void onRequest(final DartnessRequest request);

  /// This method is called after the request is executed.
  void onResponse(final DartnessResponse response);

  /// This method is called when an error occurs when executing the request.
  void onError(final Object error, final StackTrace stackTrace);
}
