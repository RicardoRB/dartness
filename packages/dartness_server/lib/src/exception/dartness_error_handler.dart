import 'dartness_catch_handler.dart';

/// A wrapper class in order to retrieve the error handler instance from the
/// annotation [ErrorHandler] and the data required to handle it internally by the
/// Dartness framework.
class DartnessErrorHandler {
  DartnessErrorHandler(this.errorHandler, this.catchErrors);

  /// The controller instance.
  final Object errorHandler;

  /// The error types that the error handler can handle.
  final List<DartnessCatchError> catchErrors;
}
