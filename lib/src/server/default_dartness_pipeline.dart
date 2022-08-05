import 'dart:io';
import 'dart:mirrors';

import 'package:dartness_server/src/exception/annotation/catch_error.dart';
import 'package:shelf/shelf.dart';

import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';
import 'dartness_pipeline.dart';

/// Default implementation of [DartnessPipeline] that uses shelf [Pipeline]
/// in order to provide an efficient way of create [DartnessMiddleware]
/// and [DartnessInterceptor].
class DefaultDartnessPipeline implements DartnessPipeline {
  DefaultDartnessPipeline({
    final Pipeline pipeline = const Pipeline(),
  }) : _pipeline = pipeline;

  /// The [Pipeline] that is handling the requests.
  final Pipeline _pipeline;
  final Set<Object> _errorHandlers = {};

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
    _errorHandlers.add(errorHandler);
    final pipeline = _pipeline.addMiddleware((final Handler innerHandler) {
      return (final Request request) async {
        try {
          final response = await Future.sync(() => innerHandler(request));
          return response;
        } catch (errorCatch) {
          for (final errorHandler in _errorHandlers) {
            final clazzDeclaration = reflectClass(errorHandler.runtimeType);
            final methods = clazzDeclaration.declarations.values
                .where(
                    (value) => value is MethodMirror && value.isRegularMethod)
                .map((method) => method as MethodMirror);
            for (final method in methods) {
              for (final metadata in method.metadata) {
                if (metadata.type == reflectClass(CatchError)) {
                  final catchError = metadata.reflectee as CatchError;
                  final containsError = catchError.errors
                      .any((error) => error == errorCatch.runtimeType);
                  if (containsError) {
                    final response = clazzDeclaration.invoke(
                      method.simpleName,
                      [errorCatch, request],
                    );

                    final result = response.reflectee;
                    if (result is Future) {
                      return await result;
                    } else {
                      return result;
                    }
                  }
                }
              }
            }
          }
        }
        return Response(HttpStatus.internalServerError);
      };
    });
    return DefaultDartnessPipeline(pipeline: pipeline);
  }
}
