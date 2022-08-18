import 'package:dartness_server/src/exception/dartness_error_handler.dart';
import 'package:dartness_server/src/exception/dartness_error_handler_register.dart';
import 'package:shelf/shelf.dart';

import '../exception/default_error_handler_register.dart';
import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';
import 'dartness_pipeline.dart';
import 'shelf_middleware/dartness_error_handler_shelf.dart';
import 'shelf_middleware/dartness_interceptor_shelf.dart';
import 'shelf_middleware/dartness_middleware_shelf.dart';

/// Default implementation of [DartnessPipeline] that uses shelf [Pipeline]
/// in order to provide an efficient way of create [DartnessMiddleware]
/// and [DartnessInterceptor].
class DefaultDartnessPipeline implements DartnessPipeline {
  DefaultDartnessPipeline({
    final Pipeline pipeline = const Pipeline(),
    final DartnessErrorHandlerRegister? errorHandlerRegister,
  })  : _pipeline = pipeline,
        _errorHandlerRegister =
            errorHandlerRegister ?? DefaultErrorHandlerRegister();

  /// The [Pipeline] that is handling the requests.
  final Pipeline _pipeline;

  /// The [DartnessErrorHandlerRegister] that is handling the errors.
  final DartnessErrorHandlerRegister _errorHandlerRegister;

  @override
  DartnessPipeline addMiddleware(final DartnessMiddleware dartnessMiddleware) {
    final shelfMiddleware = DartnessMiddlewareShelf(dartnessMiddleware);
    final pipeline = _pipeline.addMiddleware(shelfMiddleware.middleware);
    return DefaultDartnessPipeline(pipeline: pipeline);
  }

  @override
  DartnessPipeline addInterceptor(final DartnessInterceptor interceptor) {
    final shelfInterceptor = DartnessInterceptorShelf(interceptor);
    final pipeline = _pipeline.addMiddleware(shelfInterceptor.middleware);
    return DefaultDartnessPipeline(pipeline: pipeline);
  }

  @override
  Handler addHandler(final Handler handler) {
    return _pipeline.addHandler(handler);
  }

  @override
  DartnessPipeline addErrorHandler(final DartnessErrorHandler errorHandler) {
    _errorHandlerRegister.addErrorHandler(errorHandler);
    final errorHandlerShelf = DartnessErrorHandlerShelf(_errorHandlerRegister);
    final pipeline = _pipeline.addMiddleware(errorHandlerShelf.middleware);
    return DefaultDartnessPipeline(pipeline: pipeline);
  }
}
