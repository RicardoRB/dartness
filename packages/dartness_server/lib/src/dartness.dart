import 'dart:io';

import 'dartness_controller.dart';
import 'exception/dartness_error_handler.dart';
import 'server/dartness_interceptor.dart';
import 'server/dartness_middleware.dart';
import 'server/dartness_server.dart';
import 'server/default_dartness_server.dart';
import 'server/log_requests_interceptor.dart';

/// A server that delivers content, such as web pages, using the HTTP protocol
/// by [HttpServer].
class Dartness {
  /// The [DartnessServer] that is listening for connections and requests.
  late final DartnessServer _server;

  /// Creates a [DefaultDartnessServer] that listens on the specified [port] and
  /// [internetAddress].
  ///
  /// You can also add controllers by using [controllers] optional parameter or
  /// [middlewares] and [interceptors].
  Dartness({
    final int port = 8080,
    final InternetAddress? internetAddress,
    final Iterable<DartnessController> controllers = const [],
    final Iterable<DartnessMiddleware> middlewares = const [],
    final Iterable<DartnessInterceptor> interceptors = const [],
    final Iterable<DartnessErrorHandler> errorHandlers = const [],
  }) {
    _server = DefaultDartnessServer(port, internetAddress: internetAddress);
    for (final controller in controllers) {
      addController(controller);
    }
    for (final middleware in middlewares) {
      addMiddleware(middleware);
    }
    for (final interceptor in interceptors) {
      addInterceptor(interceptor);
    }
    for (final errorHandler in errorHandlers) {
      addErrorHandler(errorHandler);
    }
  }

  /// Starts the [_server].
  ///
  /// If [logRequest] is true prints the time of the request, the elapsed time for the
  /// inner handlers, the response's status code and the request URI.
  Future<void> create({
    final bool logRequest = false,
  }) async {
    if (logRequest) {
      addInterceptor(LogRequestsInterceptor());
    }
    await _server.start();
    print('Server listening on port ${_server.getPort()}');
  }

  /// Permanently stops the [Dartness] server from listening for new
  /// connections. This closes the [Stream] of [HttpRequest]s with a
  /// done event.
  ///
  /// If [force] is `true`, active connections will be closed immediately.
  Future? close({bool force = false}) {
    return _server.stop(force: force);
  }

  /// Add [controller] into [Dartness] and handles
  /// the methods annotated with [Bind] children to [Controller.method] and [Bind.method].
  ///
  /// In order to add the [controller] the class must be annotated with [Controller]
  ///
  /// Just the methods that are annotated with any [Bind] annotation
  /// will be handled.
  ///
  /// If the [Bind] annotation in the method is [Get] the method will also be
  /// called for [Head] requests matching [Bind.method]. This is because handling
  /// [Get] requests without handling [Head] is always wrong. To explicitly
  /// implement a [Head] handler the method must be created before the [Get] handler.
  ///
  /// throws [ArgumentError] if [controller] is not annotated with [Controller]
  void addController(final DartnessController controller) {
    _server.addController(controller);
  }

  /// Adds a middleware in order to listen before the http request
  void addMiddleware(final DartnessMiddleware middleware) {
    _server.addMiddleware(middleware);
  }

  /// Adds an interceptor in order to listen between an http request
  void addInterceptor(final DartnessInterceptor interceptor) {
    _server.addInterceptor(interceptor);
  }

  /// Adds an interceptor in order to listen between an http request
  void addErrorHandler(final DartnessErrorHandler errorHandler) {
    _server.addErrorHandler(errorHandler);
  }
}
