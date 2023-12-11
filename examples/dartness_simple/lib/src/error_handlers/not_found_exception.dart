import 'dart:io';

import 'package:dartness_server/exception.dart';

class NotFoundException extends HttpStatusCodeException {
  const NotFoundException(String message) : super(message, HttpStatus.notFound);
}
