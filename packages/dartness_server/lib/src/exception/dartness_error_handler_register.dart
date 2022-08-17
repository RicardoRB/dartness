import 'package:shelf/shelf.dart';

import 'dartness_error_handler.dart';

/// Interface that is used to handle the errors.
abstract class DartnessErrorHandlerRegister {
  /// Adds an error handler to the error handler.
  void addErrorHandler(final DartnessErrorHandler errorHandler);

  /// Method that handles the error by the errors added by [addErrorHandler].
  Future<dynamic> handle(final Error errorCatch, final StackTrace stackTrace,
      final Request request);
}
