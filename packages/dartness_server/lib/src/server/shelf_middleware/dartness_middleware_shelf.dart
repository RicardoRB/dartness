import 'package:shelf/shelf.dart';

import '../dartness_middleware.dart';
import '../dartness_request.dart';
import 'shelf_middleware.dart';

/// A representation of a [DartnessMiddleware] by using [Middleware]
class DartnessMiddlewareShelf implements ShelfMiddleware {
  DartnessMiddlewareShelf(this.dartnessMiddleware);

  final DartnessMiddleware dartnessMiddleware;

  @override
  Middleware get middleware => (final Handler innerHandler) {
        return (final Request request) {
          dartnessMiddleware.handle(DartnessRequest.fromShelf(request));
          return innerHandler(request);
        };
      };
}
