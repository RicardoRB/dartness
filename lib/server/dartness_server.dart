import 'dart:io';

import 'dartness_middleware.dart';

/// An interface that defines the methods that a server must implement.
abstract class DartnessServer {
  /// Returns the port that the server is listening on.
  int getPort();

  /// Returns the [InternetAddress] that the server is listening on.
  InternetAddress getAddress();

  /// Adds a middleware in order to listen between an http request
  /// and the applications running on it.
  void addMiddleware(final DartnessMiddleware middleware);

  /// Starts the server.
  Future<void> start();

  /// Permanently stops the server from listening for new connections.
  ///
  /// If [force] is `true`, active connections will be closed immediately.
  Future<void> stop({bool force = false});

  /// Adds a controller and handles the http methods
  void addController(final Object controller);
}
