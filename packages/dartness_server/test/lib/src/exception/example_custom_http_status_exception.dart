import 'dart:io';

import 'package:dartness_server/src/exception/exception.dart';

class ExampleCustomHttpStatusException extends HttpStatusException {
  const ExampleCustomHttpStatusException(String message)
      : super(message, HttpStatus.notFound);
}
