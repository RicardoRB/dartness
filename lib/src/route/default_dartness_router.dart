import 'package:shelf_router/shelf_router.dart';

import 'dartness_router.dart';
import 'dartness_router_handler.dart';
import 'shelf_route/dartness_router_handler_shelf.dart';

/// A router that can be used to handle requests.
class DefaultDartnessRouter implements DartnessRouter {
  DefaultDartnessRouter({
    final Router? router,
  }) : _router = router ?? Router();

  /// The [Router] that is handling the requests.
  final Router _router;

  // For some unknown reason, if the type [Route] isn't returned, it will throw
  // type 'Router' is not a subtype of type '(Request) => FutureOr<Response>'
  Router get router => _router;

  /// Add a [routerHandler] to the [_router] and handles the request by
  /// the [httpMethod] for the [pathRoute].
  @override
  void add(
    final String httpMethod,
    final String pathRoute,
    final DartnessRouterHandler routerHandler,
  ) {
    final dartnessRouterHandlerShelf =
        DartnessRouterHandlerShelf(routerHandler);
    _router.add(httpMethod, pathRoute, dartnessRouterHandlerShelf.handler);
  }
}
