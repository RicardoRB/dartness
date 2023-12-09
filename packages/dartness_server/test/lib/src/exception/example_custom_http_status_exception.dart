import 'dart:io';

import 'package:dartness_server/exception.dart';

class ExampleCustomHttpStatusException extends HttpStatusCodeException {
  const ExampleCustomHttpStatusException(String message)
      : super(message, HttpStatus.notFound);
}
