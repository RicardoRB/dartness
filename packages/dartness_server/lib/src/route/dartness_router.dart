import 'package:shelf_router/shelf_router.dart';

/// A router that can be used to handle requests.
abstract class DartnessRouter {
  Router get router;

  /// Adds a new [pathRoute] by the [httpMethod] handling by the [routerHandler].
  void add(
    final String httpMethod,
    final String pathRoute,
    final Function routerHandler,
  );
}
