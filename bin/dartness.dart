import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:dartness/bind/annotation/bind.dart';
import 'package:dartness/bind/annotation/controller.dart';
import 'package:dartness/bind/annotation/get.dart';
import 'package:dartness/route/router_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

/// A server that delivers content, such as web pages, using the HTTP protocol
/// by [HttpServer].
class Dartness {
  HttpServer? _server;
  final Set<Object> _controllers = {};

  Set<Object> get controllers => _controllers;

  int _port = 8080;

  int get port => _port;

  InternetAddress _address = InternetAddress.anyIPv4;

  InternetAddress get address => _address;
  final _router = Router();

  /// Starts a [Dartness] that listens on the specified [internetAddress] and
  /// [port].
  ///
  /// If [logRequest] is true prints the time of the request, the elapsed time for the
  /// inner handlers, the response's status code and the request URI.
  Future<void> create({
    final int port = 8080,
    final InternetAddress? internetAddress,
    final bool logRequest = false,
  }) async {
    _port = port;
    if (internetAddress != null) {
      _address = internetAddress;
    }

    final pipeline = Pipeline();
    if (logRequest) {
      pipeline.addMiddleware(logRequests());
    }
    final handler = pipeline.addHandler(_router);

    _server = await serve(handler, _address, _port);
    print('Server listening on port ${_server?.port}');
  }

  /// Permanently stops the [Dartness] server from listening for new
  /// connections. This closes the [Stream] of [HttpRequest]s with a
  /// done event.
  ///
  /// If [force] is `true`, active connections will be closed immediately.
  Future? close({bool force = false}) {
    return _server?.close(force: force);
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
          final handler = RouterHandler(clazzDeclaration, method);
          _router.add(
            bind.toString(),
            path,
            handler.handleRoute(),
          );
        }
      }
    }
    _controllers.add(controller);
  }
}
