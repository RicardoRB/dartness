import 'package:shelf/shelf.dart';

/// Interface that is used to handle the errors.
abstract class DartnessErrorHandler {
  /// Adds an error handler to the error handler.
  void addErrorHandler(final Object errorHandler);

  /// Method that handles the error by the errors added by [addErrorHandler].
  Future<dynamic> handle(final Error errorCatch, final StackTrace stackTrace,
      final Request request);
}
