import 'package:shelf/shelf.dart';

/// A representation as an interface of a [Middleware] used by [shelf](https://github.com/dart-lang/shelf)
/// to handle requests.
abstract interface class ShelfMiddleware {
  Middleware get middleware;
}
