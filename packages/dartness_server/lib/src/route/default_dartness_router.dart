import 'package:shelf_router/shelf_router.dart';

import 'controller_route.dart';
import 'dartness_router.dart';
import 'dartness_router_handler.dart';

/// A router that can be used to handle requests.
class DefaultDartnessRouter implements DartnessRouter {
  DefaultDartnessRouter({
    final Router? router,
  }) : _router = router ?? Router();

  /// The [Router] that is handling the requests.
  final Router _router;

  // For some unknown reason, if the type [Route] isn't returned, it will throw
  // type 'Router' is not a subtype of type '(Request) => FutureOr<Response>'
  @override
  Router get router => _router;

  /// Adds a [ControllerRoute] to the [_router] and handles the request for it.
  @override
  void add(final ControllerRoute route) {
    final dartnessRouterHandler = DartnessRouterHandler(route);
    _router.add(route.method, route.path, dartnessRouterHandler.handleRoute);
  }
}
