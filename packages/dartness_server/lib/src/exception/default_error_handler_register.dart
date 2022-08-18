import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:dartness_server/src/exception/dartness_error_handler.dart';
import 'package:dartness_server/src/exception/dartness_error_handler_register.dart';
import 'package:shelf/shelf.dart';

import 'annotation/catch_error.dart';

/// Default implementation of [DartnessErrorHandlerRegister] that handles the errors
/// by the custom handlers added by [addErrorHandler].
/// This implementation uses the [MirrorSystem] to get the [CatchError]
/// annotation to handle the errors and invoke the methods that it has been
/// implemented by the user.
class DefaultErrorHandlerRegister implements DartnessErrorHandlerRegister {
  final Set<DartnessErrorHandler> _errorHandlers = {};

  @override
  void addErrorHandler(final DartnessErrorHandler errorHandler) {
    _errorHandlers.add(errorHandler);
  }

  @override
  Future<dynamic> handle(
    final Object errorCatch,
    final StackTrace stackTrace,
    final Request request,
  ) async {
    final errorHandler = _errorHandlers
        .firstWhereOrNull((errorHandler) => errorHandler.canHandle(errorCatch));
    if (errorHandler == null) {
      return Response(HttpStatus.internalServerError);
    }

    return await Function.apply(errorHandler.handler, [errorCatch]);
  }
}
