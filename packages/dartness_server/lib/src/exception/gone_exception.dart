import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing a "Gone" error (HTTP 410).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the requested resource is no longer available at the server and no
/// forwarding address is known. It includes a human-readable [message] and has
/// an HTTP status code of [HttpStatus.gone].
class GoneException extends HttpClientErrorException {
  /// Creates a [GoneException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the gone error.
  const GoneException(String message) : super(message, HttpStatus.gone);
}
