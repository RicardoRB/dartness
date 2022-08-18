import 'package:dartness_server/exception.dart';

/// A wrapper class in order to retrieve the error handler instance from the
/// annotation [ErrorHandler] and the data required to handle it internally by the
/// Dartness framework.
class DartnessCatchError {
  DartnessCatchError(this.errorTypes, this.handler);

  /// The error types that the error handler can handle.
  final List<Type> errorTypes;

  /// The error handler function.
  final Function handler;

  /// Checks if the error handler can handle the error by runtimeType.
  bool canHandle(final Object errorCatch) =>
      errorTypes.any((errorType) => errorType == errorCatch.runtimeType);
}
