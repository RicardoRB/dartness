import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import '../bind/annotation/bind.dart';
import '../bind/annotation/controller.dart';
import '../route/default_dartness_router.dart';
import '../route/dartness_router_handler.dart';
import 'dartness_interceptor.dart';
import 'dartness_middleware.dart';
import 'dartness_pipeline.dart';
import 'dartness_server.dart';
import 'default_dartness_pipeline.dart';

/// A server that delivers content, such as web pages, using the HTTP protocol
/// by [HttpServer].
class DefaultDartnessServer implements DartnessServer {
  /// Creates a [DefaultDartnessServer] that listens on the specified [_port] and
  /// [internetAddress].
  ///
  /// If [internetAddress] is `null` the default [InternetAddress] will be [InternetAddress.anyIPv4].
  DefaultDartnessServer(
    this._port, {
    final InternetAddress? internetAddress,
  }) : _internetAddress = internetAddress ?? InternetAddress.anyIPv4;

  /// The [HttpServer] that is listening for connections.
  HttpServer? _server;

  /// The pipeline of handlers that will be used to process requests.
  DartnessPipeline _pipeline = DefaultDartnessPipeline();

  /// The [DefaultDartnessRouter] that is handling the requests.
  final _router = DefaultDartnessRouter();

  /// Controllers that are handling the requests.
  final Set<Object> _controllers = {};

  Set<Object> get controllers => _controllers;

  /// The port that the server is listening on.
  late final int _port;

  /// The type of address that the server is listening on.
  late final InternetAddress _internetAddress;

  /// Is the server listening for connections.
  bool _isStarted = false;

  /// Returns `true` if the server is listening for connections.
  bool get isStarted => _isStarted;

  @override
  int getPort() {
    return _port;
  }

  @override
  InternetAddress getAddress() {
    return _internetAddress;
  }

  /// Adds a middleware in order to listen between an http request
  /// and the applications running on it.
  @override
  void addMiddleware(final DartnessMiddleware middleware) {
    _pipeline = _pipeline.addMiddleware(middleware);
  }

  @override
  void addInterceptor(final DartnessInterceptor interceptor) {
    _pipeline = _pipeline.addInterceptor(interceptor);
  }

  /// Starts an [HttpServer] that listens by the specified [_internetAddress] and
  /// [_port].
  @override
  Future<void> start() async {
    if (_isStarted) {
      throw Exception('The server is already listening');
    }
    final handler = _pipeline.addHandler(_router.router);
    _server = await shelf_io.serve(handler, _internetAddress, _port);
    _isStarted = true;
  }

  /// Permanently stops the [HttpServer] server from listening for new
  /// connections. This closes the [Stream] of [HttpRequest]s with a
  /// done event.
  ///
  /// If [force] is `true`, active connections will be closed immediately.
  @override
  Future<void> stop({bool force = false}) async {
    await _server?.close();
    _isStarted = false;
  }

  /// Add [controller] into [_controllers] and handles
  /// the methods annotated with [Bind] children to [Controller.path] and [Bind.path].
  ///
  /// In order to add the [controller] the class must be annotated with [Controller]
  ///
  /// Just the methods that are annotated with any [Bind] annotation
  /// will be handled.
  ///
  /// If the [Bind] annotation in the method is [Get] the method will also be
  /// called for [Head] requests matching [Bind.path]. This is because handling
  /// [Get] requests without handling [Head] is always wrong. To explicitly
  /// implement a [Head] handler the method must be created before the [Get] handler.
  ///
  /// throws [ArgumentError] if [controller] is not annotated with [Controller]
  @override
  void addController(final Object controller) {
    final clazzDeclaration = reflectClass(controller.runtimeType);
    final controllerMirror = reflectClass(Controller);
    final controllerAnnotationMirror = clazzDeclaration.metadata
        .firstWhereOrNull((d) => d.type == controllerMirror);

    if (controllerAnnotationMirror == null) {
      throw ArgumentError.value(controller, 'controller',
          "doesn't contain @${controllerMirror.reflectedType}");
    }

    final ctlReflectee = controllerAnnotationMirror.reflectee as Controller;
    final methods = clazzDeclaration.declarations.values
        .where((value) => value is MethodMirror && value.isRegularMethod)
        .map((method) => method as MethodMirror);
    for (final method in methods) {
      for (final metadata in method.metadata) {
        if (metadata.type.isSubtypeOf(reflectClass(Bind))) {
          final bind = metadata.reflectee as Bind;
          final path = '${ctlReflectee.path}${bind.path}';
          final handler = DartnessRouterHandler(controller, method);
          _router.add(
            bind.toString(),
            path,
            handler,
          );
        }
      }
    }
    _controllers.add(controller);
  }

  @override
  void addErrorHandler(final Object errorHandler) {
    _pipeline = _pipeline.addErrorHandler(errorHandler);
  }
}
