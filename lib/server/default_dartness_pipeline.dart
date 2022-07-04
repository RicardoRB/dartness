import 'package:shelf/shelf.dart';

import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';
import 'dartness_pipeline.dart';

class DefaultDartnessPipeline implements DartnessPipeline {
  final Pipeline _pipeline;

  DefaultDartnessPipeline({
    Pipeline pipeline = const Pipeline(),
  }) : _pipeline = pipeline;

  @override
  DartnessPipeline addMiddleware(final DartnessMiddleware middleware) {
    final pipeline = _pipeline.addMiddleware((final Handler innerHandler) {
      return (final Request request) {
        middleware.call(request);
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
  Handler addHandler(final Handler router) {
    return _pipeline.addHandler(router);
  }
}
