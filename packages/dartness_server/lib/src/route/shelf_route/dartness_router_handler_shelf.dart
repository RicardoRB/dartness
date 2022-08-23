import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../dartness_router_handler.dart';
import 'shelf_handler.dart';

/// A representation of a [DartnessRouterHandler] by using [Function] as handler
/// in order to call [Router.add].
class DartnessRouterHandlerShelf implements ShelfHandler {
  DartnessRouterHandlerShelf(this.dartnessRouterHandler);

  final DartnessRouterHandler dartnessRouterHandler;

  @override
  Function get handler =>
      (final Request request, [final Object? extras]) async =>
          await dartnessRouterHandler.handleRoute(request, extras);
}
