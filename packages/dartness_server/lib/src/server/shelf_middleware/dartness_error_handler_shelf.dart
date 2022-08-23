import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../exception/dartness_error_handler_register.dart';
import '../../exception/http_status_exception.dart';
import '../dartness_response.dart';
import 'shelf_middleware.dart';

/// A representation of a [DartnessCatchErrorRegister] by using [Middleware]
class DartnessErrorHandlerShelf implements ShelfMiddleware {
  DartnessErrorHandlerShelf(this._errorHandler);

  final DartnessCatchErrorRegister _errorHandler;

  @override
  Middleware get middleware => (final Handler innerHandler) {
        return (final Request request) async {
          try {
            final result = await Future.sync(() => innerHandler(request));
            return result;
          } catch (error, stackTrace) {
            final result =
                await _errorHandler.handle(error, stackTrace, request);
            if (result != null) {
              if (result is DartnessResponse) {
                final body = await result.body();
                return Response(
                  result.statusCode,
                  body: body,
                  headers: result.headers,
                );
              }
              return result;
            }
            if (error is HttpStatusException) {
              return Response(
                error.statusCode,
                body: error.message,
              );
            }
            return Response(HttpStatus.internalServerError);
          }
        };
      };
}
