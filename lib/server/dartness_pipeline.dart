import 'package:shelf/shelf.dart';

import 'dartness_middleware.dart';

abstract class DartnessPipeline {
  DartnessPipeline addMiddleware(final DartnessMiddleware middleware);

  Handler addHandler(final Handler router);
}
