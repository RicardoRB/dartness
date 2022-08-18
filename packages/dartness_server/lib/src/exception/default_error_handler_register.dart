import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dartness_server/src/exception/dartness_error_handler_register.dart';
import 'package:shelf/shelf.dart';

import 'annotation/catch_error.dart';
import 'dartness_catch_handler.dart';

/// Default implementation of [DartnessCatchErrorRegister] that handles the errors
/// by the custom handlers added by [addCatchError].
/// This implementation uses the [MirrorSystem] to get the [CatchError]
/// annotation to handle the errors and invoke the methods that it has been
/// implemented by the user.
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

    return await Function.apply(catchError.handler, [errorCatch]);
  }
}
