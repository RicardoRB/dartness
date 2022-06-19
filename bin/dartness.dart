import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:dartness/binds/get.dart';
import 'package:dartness/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class Dartness {
  HttpServer? _server;
  final Set<Object> _controllers = {};

  Set<Object> get controllers => _controllers;

  int _port = 8080;
  InternetAddress _address = InternetAddress.anyIPv4;

  final _router = Router();

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

  Future? close({bool force = false}) {
    return _server?.close(force: force);
  }

  void addController(final Object controller) {
    final clazzDeclaration = reflectClass(controller.runtimeType);
    final controllerMirror = reflectClass(Controller);
    final controllerAnnotationMirror = clazzDeclaration.metadata
        .firstWhereOrNull((d) => d.type == controllerMirror);

    if (controllerAnnotationMirror == null) {
      throw ArgumentError.value(controller, 'controller',
          "doesn't contain @${controllerMirror.reflectedType}");
    }

    final methods = clazzDeclaration.declarations.values
        .where((value) => value is MethodMirror && value.isRegularMethod)
        .map((method) => method as MethodMirror);
    for (final method in methods) {
      for (var metadata in method.metadata) {
        if (metadata.type == reflectClass(Get)) {
          _handleGet(
              controllerAnnotationMirror, metadata, clazzDeclaration, method);
        }
      }
    }
    _controllers.add(controller);
  }

  void _handleGet(
      final InstanceMirror controllerAnnotationMirror,
      final InstanceMirror metadata,
      final ClassMirror clazzDeclaration,
      final MethodMirror method) {
    final path = '${controllerAnnotationMirror.reflectee.path}'
        '${metadata.reflectee.path}';
    _router.get(path, (final Request request) async {
      //TODO path params and query params
      final params = request.params.values.toList();
      final response = clazzDeclaration.invoke(method.simpleName, params);
      var result = response.reflectee;
      if (result is Future) {
        return await result;
      } else if (result is Response) {
        return result;
      } else if (result is Iterable || result is Map || result is Object) {
        return Response.ok(jsonEncode(result));
      } else {
        return Response.ok(result);
      }
    });
  }
}
