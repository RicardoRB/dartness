import 'dart:io';

import 'package:dartness_server/modules.dart';

import 'exception/dartness_error_handler.dart';
import 'route/dartness_controller.dart';
import 'server/dartness_application_options.dart';
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
  late final DartnessApplicationOptions _options;

  /// Starts the [_server].
  ///
  /// If [logRequest] is true prints the time of the request, the elapsed time for the
  /// inner handlers, the response's status code and the request URI.
  Future<DartnessServer> create(
    final Module module, {
    final DartnessApplicationOptions? options,
  }) async {
    _options = options ?? DartnessApplicationOptions();

    _server = DefaultDartnessServer(
      _options.port,
      internetAddress: _options.internetAddress,
    );
    _initModule(module);

    if (options?.logRequest == true) {
      _addInterceptor(LogRequestsInterceptor());
    }
    await _server.start();
    print('Server listening on port ${_server.getPort()}');
    return _server;
  }

  /// Initializes the given [module] and its dependencies.
  void _initModule(final Module module) {
    for (final import in module.metadata.imports) {
      _initModule(import);
    }

    for (final controller in module.metadata.controllers) {
      _addController(controller);
    }

    _addProviders(module);
  }

  void _addProviders(Module module) {
    for (final provider in module.metadata.providers) {
      if (provider is DartnessMiddleware) {
        _addMiddleware(provider);
      }

      if (provider is DartnessInterceptor) {
        _addInterceptor(provider);
      }

      if (provider is DartnessErrorHandler) {
        _addErrorHandler(provider);
      }
    }
  }

  /// Add [controller] into [Dartness] and handles
  /// the methods annotated with [Bind] children to [Controller] and [Bind.method].
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
  void _addController(final DartnessController controller) {
    _server.addController(controller);
  }

  /// Adds a middleware in order to listen before the http request
  void _addMiddleware(final DartnessMiddleware middleware) {
    _server.addMiddleware(middleware);
  }

  /// Adds an interceptor in order to listen between an http request
  void _addInterceptor(final DartnessInterceptor interceptor) {
    _server.addInterceptor(interceptor);
  }

  /// Adds an interceptor in order to listen between an http request
  void _addErrorHandler(final DartnessErrorHandler errorHandler) {
    _server.addErrorHandler(errorHandler);
  }
}
