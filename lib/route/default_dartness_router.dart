import 'package:shelf_router/shelf_router.dart';

import 'dartness_router.dart';
import 'router_handler.dart';

/// A router that can be used to handle requests.
class DefaultDartnessRouter implements DartnessRouter {
  /// The [Router] that is handling the requests.
  final _router = Router();

  // For some unknown reason, if the type [Route] isn't returned, it will throw
  // type 'Router' is not a subtype of type '(Request) => FutureOr<Response>'
  Router get router => _router;

  /// Add a [routerHandler] to the [_router] and handles the request by
  /// the [httpMethod] for the [pathRoute].
  @override
  void add(
    final String httpMethod,
    final String pathRoute,
    final RouterHandler routerHandler,
  ) {
    _router.add(httpMethod, pathRoute, routerHandler.handleRoute());
  }
}
