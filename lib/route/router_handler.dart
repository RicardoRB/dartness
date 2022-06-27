import 'dart:convert';
import 'dart:mirrors';

import 'package:dartness/bind/annotation/path_param.dart';
import 'package:dartness/bind/annotation/query_param.dart';
import 'package:logger/logger.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterHandler {
  final _logger = Logger();

  final ClassMirror _clazzMirror;
  final MethodMirror _methodMirror;

  RouterHandler(this._clazzMirror, this._methodMirror);

  /// Handles the route's response and invoke the [_methodMirror] in [_clazzMirror]
  Function handleRoute() {
    return (final Request request, [final Object? extras]) async {
      try {
        final Map<String, String> pathParams = Map.of(request.params)
          ..removeWhere((key, value) {
            return request.url.queryParameters.containsKey(key);
          });
        final methodParams = [];
        if (pathParams.isNotEmpty) {
          final params = _getPathParamsValues(_methodMirror, pathParams);
          methodParams.addAll(params);
        }
        if (request.url.queryParameters.isNotEmpty) {
          final queryParams =
              _getQueryParamsValues(_methodMirror, request.url.queryParameters);
          methodParams.addAll(queryParams);
        }
        final response =
            _clazzMirror.invoke(_methodMirror.simpleName, methodParams);
        var result = response.reflectee;
        if (result is Future) {
          return Response.ok(await result);
        } else if (result is Response) {
          return result;
        } else if (result is Iterable || result is Map || result is Object) {
          return Response.ok(jsonEncode(result));
        } else {
          return Response.ok(result);
        }
      } catch (e, stack) {
        _logger.e('Error handling route', e, stack);
        return Response.internalServerError(body: e.toString());
      }
    };
  }

  /// Returns the values of the [method] parameters based on the [pathParams]
  ///
  /// In order to invoke the [method] the parameters must be in the same order
  /// and must has the same name.
  List<Object> _getPathParamsValues(
      final MethodMirror method, final Map<String, String> pathParams) {
    final List<Object> params = [];
    final methodPathParams = method.parameters.where((element) {
      return element.metadata.any((metadata) {
        return metadata.reflectee.runtimeType == PathParam;
      });
    });
    for (final methodParam in methodPathParams) {
      final value = _getParamValue(methodParam, pathParams);
      _addTypedParam(methodParam, params, value);
    }
    return params;
  }

  /// Gets the [method] parameters values from the [queryParams].
  /// The [queryParams] must be in the same order as the [method] parameters.
  List<Object> _getQueryParamsValues(
      final MethodMirror method, final Map<String, String> queryParameters) {
    final List<Object> params = [];
    // TODO: check if the query params are in the same order as the method params
    final methodQueryParams = method.parameters.where((element) {
      return element.metadata.any((metadata) {
        return metadata.reflectee.runtimeType == QueryParam;
      });
    });

    for (final methodParam in methodQueryParams) {
      final value = _getParamValue(methodParam, queryParameters);
      _addTypedParam(methodParam, params, value);
    }
    return params;
  }

  /// Return the param value by the [methodParam] and the map [params]
  String _getParamValue(
      final ParameterMirror methodParam, final Map<String, String> params) {
    final paramName = MirrorSystem.getName(methodParam.simpleName);
    final value = params[paramName];
    if (value == null) {
      throw ArgumentError.value(methodParam, 'methodParam',
          'missing parameter ${methodParam.simpleName}');
    }
    return value;
  }

  /// Adds the [value] to the [params] based on the [methodParam] reflected type.
  void _addTypedParam(
      ParameterMirror methodParam, List<Object> params, String value) {
    if (methodParam.type.reflectedType == int) {
      params.add(int.parse(value));
    } else if (methodParam.type.reflectedType == double) {
      params.add(double.parse(value));
    } else if (methodParam.type.reflectedType == String) {
      params.add(value);
    } else if (methodParam.type.reflectedType == bool) {
      params.add(value == 'true');
    } else if (methodParam.type.reflectedType == Object) {
      params.add(value);
    } else {
      throw ArgumentError.value(
          methodParam.type.reflectedType, 'methodParam.type.reflectedType');
    }
  }
}
