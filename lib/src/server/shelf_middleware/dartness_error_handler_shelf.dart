import 'dart:io';

import 'package:shelf/shelf.dart';

import '../../exception/dartness_error_handler.dart';
import 'shelf_middleware.dart';

/// A representation of a [DartnessErrorHandler] by using [Middleware]
class DartnessErrorHandlerShelf implements ShelfMiddleware {
  DartnessErrorHandlerShelf(this._errorHandler);

  final DartnessErrorHandler _errorHandler;

  @override
  Middleware get middleware => (final Handler innerHandler) {
        return (final Request request) async {
          try {
            return await Future.sync(() => innerHandler(request));
          } on Error catch (errorCatch, stackTrace) {
            return await _errorHandler.handle(errorCatch, stackTrace, request);
          } catch (error) {
            return Response(HttpStatus.internalServerError);
          }
        };
      };
}
