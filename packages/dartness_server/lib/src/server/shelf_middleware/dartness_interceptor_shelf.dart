import 'dart:io';

import 'package:dartness_server/src/server/dartness_request.dart';
import 'package:shelf/shelf.dart';

import '../dartness_interceptor.dart';
import '../dartness_response.dart';
import 'shelf_middleware.dart';

/// A representation of a [DartnessInterceptor] by using [Middleware]
class DartnessInterceptorShelf implements ShelfMiddleware {
  DartnessInterceptorShelf(this.dartnessInterceptor);

  final DartnessInterceptor dartnessInterceptor;

  @override
  Middleware get middleware => (final Handler innerHandler) {
        return (final Request request) async {
          dartnessInterceptor.onRequest(DartnessRequest.fromShelf(request));
          try {
            final response = await Future.sync(() => innerHandler(request));
            dartnessInterceptor
                .onResponse(DartnessResponse.fromShelf(response));
            return response;
          } catch (error, stackTrace) {
            dartnessInterceptor.onError(error, stackTrace);
          }
          return Response(HttpStatus.internalServerError);
        };
      };
}
