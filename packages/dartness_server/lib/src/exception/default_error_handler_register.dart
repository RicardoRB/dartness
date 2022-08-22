import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dartness_server/src/exception/dartness_error_handler_register.dart';
import 'package:shelf/shelf.dart';

import '../server/dartness_request.dart';
import 'dartness_catch_handler.dart';

/// Default implementation of [DartnessCatchErrorRegister] that handles the errors
/// by the custom handlers added by [addCatchError].
class DefaultErrorHandlerRegister implements DartnessCatchErrorRegister {
  final Set<DartnessCatchError> _catchErrors = {};

  @override
  void addCatchError(final DartnessCatchError errorHandler) {
    _catchErrors.add(errorHandler);
  }

  @override
  Future<dynamic> handle(
    final Object errorCatch,
    final StackTrace stackTrace,
    final Request request,
  ) async {
    final catchError = _catchErrors
        .firstWhereOrNull((errorHandler) => errorHandler.canHandle(errorCatch));
    if (catchError == null) {
      return Response(HttpStatus.internalServerError);
    }

    return await Function.apply(catchError.handler, [
      errorCatch,
      DartnessRequest.fromShelf(request),
    ]);
  }
}
