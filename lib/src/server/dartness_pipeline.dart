import 'package:shelf/shelf.dart';

import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';

/// A helper that makes it easy to compose a set of [DartnessMiddleware], [DartnessMiddleware] and a
/// [Handler].
abstract class DartnessPipeline {
  /// Returns a new [DartnessPipeline] with [middleware] added to the existing set of
  /// [DartnessMiddleware].
  DartnessPipeline addMiddleware(final DartnessMiddleware middleware);

  /// Returns a new [DartnessPipeline] with [middleware] added to the existing set of
  /// [DartnessInterceptor].
  DartnessPipeline addInterceptor(final DartnessInterceptor interceptor);

  /// Returns a new [Handler] with [handler]
  Handler addHandler(final Handler handler);

  /// Returns a new [DataHandler] with [errorHandler] added to the existing set of
  /// [Object].
  DartnessPipeline addErrorHandler(final Object errorHandler);
}
