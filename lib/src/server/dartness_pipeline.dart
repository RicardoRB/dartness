import 'package:shelf/shelf.dart';

import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';

/// A helper that makes it easy to compose a set of [DartnessMiddleware], [DartnessMiddleware] and a
/// [Handler].
abstract class DartnessPipeline {
  /// Returns a new [DartnessPipeline] with [dartnessMiddleware] added to the existing set of
  /// [DartnessMiddleware].
  DartnessPipeline addMiddleware(final DartnessMiddleware dartnessMiddleware);

  /// Returns a new [DartnessPipeline] with [dartnessInterceptor] added to the existing set of
  /// [DartnessInterceptor].
  DartnessPipeline addInterceptor(final DartnessInterceptor dartnessInterceptor);

  /// Returns a new [Handler] with [handler]
  Handler addHandler(final Handler handler);

  /// Returns a new [DartnessPipeline] with [errorHandler] added to the existing set of
  /// handlers.
  DartnessPipeline addErrorHandler(final Object errorHandler);
}
