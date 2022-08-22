import 'dart:convert';
import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/exception.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../string_utils.dart';

/// A router handler for handling request for a [ControllerRoute]
/// with his metadata and the method [ControllerRoute.handler] with the metadata.
class DartnessRouterHandler {
  DartnessRouterHandler(this._route);

  final ControllerRoute _route;

  /// Handles the route's response and invoke the [Function] in [ControllerRoute.handler]
  Future<Response> handleRoute(final Request request,
      [final Object? extras]) async {
    final List<dynamic> positionalArguments = [];
    final Map<Symbol, dynamic> namedArguments = {};
    for (final param in _route.params) {
      if (param.isPositional) {
        if (param.isPath) {
          final pathParam = _getPathParam(request, param);
          final value = stringToType(pathParam, param.type);
          positionalArguments.add(value);
        } else if (param.isQuery) {
          final queryParam = _getQueryParam(request, param);
          final value = stringToType(queryParam, param.type);
          positionalArguments.add(value);
        } else {
          final bodyJson = await request.body.asJson;
          final bodyInstance = param.fromJson?.call(bodyJson);
          positionalArguments.add(bodyInstance);
        }
      } else {
        if (param.isPath) {
          final pathParam = _getPathParam(request, param);
          final value = stringToType(pathParam, param.type);
          namedArguments[Symbol(param.name)] = value;
        } else {
          final queryParam = _getQueryParam(request, param);
          final value = stringToType(queryParam, param.type);
          namedArguments[Symbol(param.name)] = value;
        }
      }
    }
    final dynamic response;
    try {
      response = await Function.apply(
          _route.handler, positionalArguments, namedArguments);
    } on HttpStatusException catch (e) {
      return Response(e.statusCode, body: e.message);
    } catch (e) {
      return Response(HttpStatus.internalServerError, body: e.toString());
    }
    
    dynamic body;
    if (response is Response) {
      return response;
    } else if (response is Iterable || response is Map || response is num) {
      body = jsonEncode(response);
    } else {
      try {
        body = jsonEncode(response.toJson());
      } on NoSuchMethodError catch (_) {
        body = response;
      }
    }

    return Response(
      _route.httpCode ?? HttpStatus.ok,
      body: body,
      headers: _route.headers,
    );
  }

  dynamic _getQueryParam(Request request, DartnessParam param) =>
      request.url.queryParameters[param.name] ?? param.defaultValue;

  dynamic _getPathParam(Request request, DartnessParam param) =>
      request.params[param.name] ?? param.defaultValue;
}
