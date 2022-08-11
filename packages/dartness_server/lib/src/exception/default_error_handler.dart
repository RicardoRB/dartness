import 'dart:io';
import 'dart:mirrors';

import 'package:dartness_server/src/exception/dartness_error_handler.dart';
import 'package:shelf/shelf.dart';

import 'annotation/catch_error.dart';

/// Default implementation of [DartnessErrorHandler] that handles the errors
/// by the custom handlers added by [addErrorHandler].
/// This implementation uses the [MirrorSystem] to get the [CatchError]
/// annotation to handle the errors and invoke the methods that it has been
/// implemented by the user.
class DefaultErrorHandler implements DartnessErrorHandler {
  @override
  void addErrorHandler(final Object errorHandler) {
    _errorHandlers.add(errorHandler);
  }

  final Set<Object> _errorHandlers = {};

  @override
  Future<dynamic> handle(final Error errorCatch, final StackTrace stackTrace,
      final Request request) async {
    for (final errorHandler in _errorHandlers) {
      final clazzDeclaration = reflectClass(errorHandler.runtimeType);
      final methods = clazzDeclaration.declarations.values
          .where((value) => value is MethodMirror && value.isRegularMethod)
          .map((method) => method as MethodMirror);
      for (final method in methods) {
        for (final metadata in method.metadata) {
          if (metadata.type == reflectClass(CatchError)) {
            final catchError = metadata.reflectee as CatchError;
            final containsError = catchError.errors
                .any((error) => error == errorCatch.runtimeType);
            if (containsError) {
              final reflectedErrorHandler = reflect(errorHandler);
              final response = reflectedErrorHandler.invoke(
                method.simpleName,
                [errorCatch, request],
              );

              final result = response.reflectee;
              if (result is Future) {
                return result;
              } else {
                return Future.value(result);
              }
            }
          }
        }
      }
    }
    return Response(HttpStatus.internalServerError);
  }
}
