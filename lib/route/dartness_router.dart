import 'package:dartness_server/route/router_handler.dart';

/// A router that can be used to handle requests.
abstract class DartnessRouter {
  /// Adds a new [pathRoute] by the [httpMethod] handling by the [routerHandler].
  void add(
    final String httpMethod,
    final String pathRoute,
    final RouterHandler routerHandler,
  );
}
