import 'package:shelf/shelf.dart';

import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';

abstract class DartnessPipeline {
  DartnessPipeline addMiddleware(final DartnessMiddleware middleware);

  DartnessPipeline addInterceptor(final DartnessInterceptor interceptor);

  Handler addHandler(final Handler router);
}
