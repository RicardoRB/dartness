import 'package:shelf_router/shelf_router.dart';

/// A representation as an interface of a route handler used by [shelf](https://github.com/dart-lang/shelf)
/// to handle requests.
///
/// Since in [Router.add] the handler is a [Function] and not having a logical
/// representation by code.
abstract interface class ShelfHandler {
  Function get handler;
}
