import 'dart:io';

import 'package:dartness_server/src/exception/http_status_exception.dart';

class NotFoundException extends HttpStatusException {
  const NotFoundException(String message) : super(message, HttpStatus.notFound);
}
