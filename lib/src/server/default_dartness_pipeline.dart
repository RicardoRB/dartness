import 'dart:io';

import 'package:dartness_server/src/exception/dartness_error_handler.dart';
import 'package:shelf/shelf.dart';

import '../exception/default_error_handler.dart';
import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';
import 'dartness_pipeline.dart';

/// Default implementation of [DartnessPipeline] that uses shelf [Pipeline]
/// in order to provide an efficient way of create [DartnessMiddleware]
/// and [DartnessInterceptor].
class DefaultDartnessPipeline implements DartnessPipeline {
  DefaultDartnessPipeline({
    final Pipeline pipeline = const Pipeline(),
    final DartnessErrorHandler? errorHandler,
  })  : _pipeline = pipeline,
        _errorHandler = errorHandler ?? DefaultErrorHandler();

  /// The [Pipeline] that is handling the requests.
  final Pipeline _pipeline;

  /// The [DartnessErrorHandler] that is handling the errors.
  final DartnessErrorHandler _errorHandler;

  @override
  DartnessPipeline addMiddleware(final DartnessMiddleware middleware) {
    final pipeline = _pipeline.addMiddleware((final Handler innerHandler) {
      return (final Request request) {
        middleware.handle(request);
        return innerHandler(request);
      };
    });

    return DefaultDartnessPipeline(pipeline: pipeline);
  }

  @override
  DartnessPipeline addInterceptor(final DartnessInterceptor interceptor) {
    final pipeline = _pipeline.addMiddleware((final Handler innerHandler) {
      return (final Request request) {
        interceptor.onRequest(request);
        return Future.sync(() => innerHandler(request))
            .then((final Response response) {
          interceptor.onResponse(response);
          return response;
        }).catchError((Object error, StackTrace stackTrace) {
          interceptor.onError(error, stackTrace);
        });
      };
    });
    return DefaultDartnessPipeline(pipeline: pipeline);
  }

  @override
  Handler addHandler(final Handler handler) {
    return _pipeline.addHandler(handler);
  }

  @override
  DartnessPipeline addErrorHandler(Object errorHandler) {
    _errorHandler.addErrorHandler(errorHandler);
    final pipeline = _pipeline.addMiddleware((final Handler innerHandler) {
      return (final Request request) async {
        try {
          return await Future.sync(() => innerHandler(request));
        } on Error catch (errorCatch, stackTrace) {
          return await _errorHandler.handle(errorCatch, stackTrace, request);
        } catch (error) {
          return Response(HttpStatus.internalServerError);
        }
      };
    });
    return DefaultDartnessPipeline(pipeline: pipeline);
  }
}
