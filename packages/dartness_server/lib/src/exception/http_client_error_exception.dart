import 'package:dartness_server/exception.dart';

class HttpClientErrorException extends HttpStatusCodeException {
  const HttpClientErrorException(super.message, super.statusCode);
}
