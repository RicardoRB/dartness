import 'dart:convert';
import 'dart:io';

import 'package:dartness_server/src/string_extension.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../exception/http_status_code_exception.dart';
import 'controller_route.dart';
import 'dartness_param.dart';

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
          if (pathParam is String) {
            final value = pathParam.stringToType(param.type);
            positionalArguments.add(value);
          } else {
            positionalArguments.add(pathParam);
          }
        } else if (param.isQuery) {
          final queryParam = _getQueryParam(request, param);
          if (queryParam is String) {
            final value = queryParam.stringToType(param.type);
            positionalArguments.add(value);
          } else {
            positionalArguments.add(queryParam);
          }
        } else {
          final bodyJson = await request.body.asJson;
          final bodyInstance = param.fromJson?.call(bodyJson);
          positionalArguments.add(bodyInstance);
        }
      } else {
        if (param.isPath) {
          final pathParam = _getPathParam(request, param);
          if (pathParam is String) {
            final value = pathParam.stringToType(param.type);
            namedArguments[Symbol(param.name)] = value;
          } else {
            namedArguments[Symbol(param.name)] = pathParam;
          }
        } else {
          final Object? queryParam = _getQueryParam(request, param);
          if (queryParam is String) {
            final value = queryParam.stringToType(param.type);
            namedArguments[Symbol(param.name)] = value;
          } else {
            namedArguments[Symbol(param.name)] = queryParam;
          }
        }
      }
    }
    final dynamic response;
    try {
      response = await Function.apply(
          _route.handler, positionalArguments, namedArguments);
    } on HttpStatusCodeException catch (e) {
      return Response(e.statusCode, body: e.message);
    } catch (e) {
      rethrow;
    }

    dynamic body;
    if (response is Response) {
      return response;
    } else if (response is Iterable) {
      body = jsonEncode(response.toList());
    } else if (response is Map || response is num) {
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

  Object? _getQueryParam(final Request request, final DartnessParam param) {
    final all = request.url.queryParametersAll;
    final foundAll = all[param.name];
    if (foundAll != null && foundAll.length > 1) {
      return all[param.name];
    }
    return request.url.queryParameters[param.name] ?? param.defaultValue;
  }

  Object? _getPathParam(final Request request, final DartnessParam param) =>
      request.params[param.name] ?? param.defaultValue;
}
