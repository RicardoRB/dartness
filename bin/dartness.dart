import 'dart:io';

import 'package:dartness/bind/annotation/bind.dart';
import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/get.dart';
import 'package:dartness/server/dartness_server.dart';
import 'package:dartness/server/default_dartness_server.dart';
import 'package:shelf/shelf.dart';

/// A server that delivers content, such as web pages, using the HTTP protocol
/// by [HttpServer].
class Dartness {
  /// The [DartnessServer] that is listening for connections and requests.
  late final DartnessServer _server;

  /// Creates a [DefaultDartnessServer] that listens on the specified [port] and
  /// [internetAddress].
  Dartness({
    final int port = 8080,
    final InternetAddress? internetAddress,
  }) {
    _server = DefaultDartnessServer(port, internetAddress: internetAddress);
  }

  /// Starts the [_server].
  ///
  /// If [logRequest] is true prints the time of the request, the elapsed time for the
  /// inner handlers, the response's status code and the request URI.
  Future<void> create({
    final bool logRequest = false,
  }) async {
    if (logRequest) {
      _server.addMiddleware(logRequests());
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

  /// Add [controller] into [_controllers] and handles
  /// the methods annotated with [Bind] children to [Controller.path] and [Bind.path].
  ///
  /// In order to add the [controller] the class must be annotated with [Controller]
  ///
  /// Just the methods that are static and are annotated with any [Bind] annotation
  /// will be handled.
  ///
  /// If the [Bind] annotation in the method is [Get] the method will also be
  /// called for [Head] requests matching [Bind.path]. This is because handling
  /// [Get] requests without handling [Head] is always wrong. To explicitly
  /// implement a [Head] handler the method must be created before the [Get] handler.
  ///
  /// throws [ArgumentError] if [controller] is not annotated with [Controller]
  void addController(final Object controller) {
    _server.addController(controller);
  }
}
