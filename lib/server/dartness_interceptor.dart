import 'package:shelf/shelf.dart';

abstract class DartnessInterceptor {
  void onRequest(final Request request);

  void onResponse(final Response response);

  void onError(final Object error, final StackTrace stackTrace);
}
