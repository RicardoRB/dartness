import 'package:shelf/shelf.dart';

abstract class DartnessPipeline {
  void addMiddleware(final Middleware middleware);

  Handler addHandler(final Handler router);
}
