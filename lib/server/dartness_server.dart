import 'dart:io';

import 'package:shelf/shelf.dart';

/// An interface that defines the methods that a server must implement.
abstract class DartnessServer {
  /// Returns the port that the server is listening on.
  int getPort();

  /// Returns the [InternetAddress] that the server is listening on.
  InternetAddress getAddress();

  /// Adds a middleware in order to listen between an http request
  /// and the applications running on it.
  void addMiddleware(final Middleware middleware);

  /// Starts the server.
  Future<void> start();

  /// Permanently stops the server from listening for new connections.
  Future<void> stop({bool force = false});

  /// Adds a new controller in order to lise for http requests.
  void addController(final Object controller);
}
