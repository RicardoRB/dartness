import 'dart:io';

import 'package:dartness_server/exception.dart';

class ExampleCustomHttpStatusException extends HttpStatusException {
  const ExampleCustomHttpStatusException(String message)
      : super(message, HttpStatus.notFound);
}
