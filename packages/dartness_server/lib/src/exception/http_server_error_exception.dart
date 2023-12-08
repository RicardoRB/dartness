import 'package:dartness_server/exception.dart';

class HttpServerErrorException extends HttpStatusCodeException {
  const HttpServerErrorException(super.message, super.statusCode);
}
