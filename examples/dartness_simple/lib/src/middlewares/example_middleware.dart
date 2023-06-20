import 'package:dartness_server/server.dart';

class ExampleMiddleware implements DartnessMiddleware {
  @override
  void handle(DartnessRequest request) {
    print(request.requestedUri);
  }
}
