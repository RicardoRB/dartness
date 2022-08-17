import 'package:dartness_server/server.dart';
import 'package:shelf/src/request.dart';

class ExampleMiddleware implements DartnessMiddleware {
  @override
  void handle(Request request) {
    print(request.requestedUri);
  }
}
