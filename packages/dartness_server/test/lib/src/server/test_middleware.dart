import 'dart:io';

import 'package:dartness_server/server.dart';

class TestMiddleware implements DartnessMiddleware {
  @override
  void handle(DartnessRequest request) {
    if (!request.headers.containsKey(HttpHeaders.authorizationHeader)) {
      throw HttpException("Unauthorized", uri: request.requestedUri);
    }
  }
}
