import 'dart:io';

import 'package:dartness_server/src/exception/http_client_error_exception.dart';

/// A custom exception representing an "Unprocessable Entity" error (HTTP 422).
///
/// This exception extends [HttpClientErrorException] and is thrown to indicate
/// that the server understands the content type of the request entity but was
/// unable to process the contained instructions. It includes a human-readable
/// [message] and has an HTTP status code of [HttpStatus.unprocessableEntity].
class UnprocessableEntityException extends HttpClientErrorException {
  /// Creates an [UnprocessableEntityException] with the specified [message].
  ///
  /// The [message] is a human-readable description of the unprocessable entity error.
  const UnprocessableEntityException(String message)
      : super(message, HttpStatus.unprocessableEntity);
}
