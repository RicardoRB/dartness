import 'package:shelf/shelf.dart';

abstract class DartnessMiddleware {
  void call(final Request request);
}
