import 'package:shelf/shelf.dart';

import 'dartness_catch_handler.dart';

/// Interface that is used to handle the errors.
abstract class DartnessCatchErrorRegister {
  /// Adds an error handler to the error handler.
  void addCatchError(final DartnessCatchError errorHandler);

  /// Method that handles the error by the errors added by [addCatchError].
  Future<dynamic> handle(
      final Object error, final StackTrace stackTrace, final Request request);
}
