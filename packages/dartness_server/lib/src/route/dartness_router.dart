import 'package:shelf_router/shelf_router.dart';

import '../../dartness.dart';

/// A router that can be used to handle requests.
abstract class DartnessRouter {
  Router get router;

  /// Adds a new [pathRoute] by the [httpMethod] handling by the [routerHandler].
  void add(final ControllerRoute route);
}
