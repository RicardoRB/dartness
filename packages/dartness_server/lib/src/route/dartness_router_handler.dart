import 'dart:convert';
import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../exception/http_status_exception.dart';
import '../string_utils.dart';

/// A router handler for handling request for a [_controller]
/// with his metadata and the method [MethodMirror] with the metadata.
class DartnessRouterHandler {
  DartnessRouterHandler(this._route);

  final ControllerRoute _route;

  /// Handles the route's response and invoke the [_methodMirror] in [_controller]
  Future<Response> handleRoute(final Request request,
      [final Object? extras]) async {
    try {
      final positionalArguments = [];
      final Map<Symbol, dynamic> namedArguments = {};
      for (final param in _route.params) {
        if (param.isPositional) {
          if (param.isPath) {
            final pathParam = getPathParam(request, param);
            final value = stringToType(pathParam, param.type);
            positionalArguments.add(value);
          } else {
            final queryParam = getQueryParam(request, param);
            final value = stringToType(queryParam, param.type);
            positionalArguments.add(value);
          }
        } else {
          if (param.isPath) {
            final pathParam = getPathParam(request, param);
            final value = stringToType(pathParam, param.type);
            namedArguments[Symbol(param.name)] = value;
          } else {
            final queryParam = getQueryParam(request, param);
            final value = stringToType(queryParam, param.type);
            namedArguments[Symbol(param.name)] = value;
          }
        }
      }

      final response = await Function.apply(
          _route.handler, positionalArguments, namedArguments);

      final dynamic body;
      if (response is Response) {
        return response;
      } else if (response is Iterable || response is Map) {
        body = jsonEncode(response);
      } else if (response?.toJson() != null) {
        body = jsonEncode(response.toJson());
      } else {
        body = response;
      }

      return Response(
        _route.httpCode ?? HttpStatus.ok,
        body: body,
        headers: _route.headers,
      );
    } on HttpStatusException catch (e) {
      return Response(
        e.statusCode,
        body: e.message,
      );
    }
  }

  getQueryParam(Request request, DartnessParam param) =>
      request.url.queryParameters[param.name] ?? param.defaultValue;

  getPathParam(Request request, DartnessParam param) =>
      request.params[param.name] ?? param.defaultValue;
}
