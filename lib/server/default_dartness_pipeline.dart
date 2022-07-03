import 'package:shelf/shelf.dart';

import 'dartness_pipeline.dart';

class DefaultDartnessPipeline implements DartnessPipeline {
  final _pipeline = Pipeline();

  @override
  void addMiddleware(final Middleware middleware) {
    _pipeline.addMiddleware(middleware);
  }

  @override
  Handler addHandler(final Handler router) {
    return _pipeline.addHandler(router);
  }
}
