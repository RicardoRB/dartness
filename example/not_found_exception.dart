import 'dart:io';

import 'package:dartness_server/dartness.dart';

class NotFoundException extends HttpStatusException {
  const NotFoundException(String message) : super(message, HttpStatus.notFound);
}
