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

        final Map<String, Object> allParamsWithValue = {};
        if (pathParams.isNotEmpty) {
          final pathParamValues =
              _getPathParamsValues(_methodMirror, pathParams);
          allParamsWithValue.addAll(pathParamValues);
        }
        if (request.url.queryParameters.isNotEmpty) {
          final queryParamValues =
              _getQueryParamsValues(_methodMirror, request.url.queryParameters);
          allParamsWithValue.addAll(queryParamValues);
        }

        final methodParams = [];
        for (final parameter in _methodMirror.parameters) {
          final paramName = MirrorSystem.getName(parameter.simpleName);
          if (allParamsWithValue.containsKey(paramName)) {
            methodParams.add(allParamsWithValue[paramName]);
          }
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
  Map<String, Object> _getPathParamsValues(
    final MethodMirror method,
    final Map<String, String> pathParams,
  ) {
    final methodPathParams = method.parameters.where((element) {
      return element.metadata.any((metadata) {
        return metadata.reflectee.runtimeType == PathParam;
      });
    });
    return _getParamsAndValues(methodPathParams, pathParams);
  }

  Map<String, Object> _getParamsAndValues(
    final Iterable<ParameterMirror> methodPathParams,
    final Map<String, String> pathParams,
  ) {
    final Map<String, Object> params = {};
    for (final methodParam in methodPathParams) {
      final value = _getParamValue(methodParam, pathParams);
      final typedParam = _getTypedParam(methodParam, value);
      final paramName = MirrorSystem.getName(methodParam.simpleName);
      params[paramName] = typedParam;
    }
    return params;
  }

  /// Gets the [method] parameters values from the [queryParams].
  Map<String, Object> _getQueryParamsValues(
    final MethodMirror method,
    final Map<String, String> queryParameters,
  ) {
    final methodQueryParams = method.parameters.where((element) {
      return element.metadata.any((metadata) {
        return metadata.reflectee.runtimeType == QueryParam;
      });
    });

    return _getParamsAndValues(methodQueryParams, queryParameters);
  }

  /// Return the param value by the [methodParam] and the map [params]
  String _getParamValue(
    final ParameterMirror methodParam,
    final Map<String, String> params,
  ) {
    final paramName = MirrorSystem.getName(methodParam.simpleName);
    final value = params[paramName];
    if (value == null) {
      throw ArgumentError.value(methodParam, 'methodParam',
          'missing parameter ${methodParam.simpleName}');
    }
    return value;
  }

  /// Gets the value param from the [methodParam] and returns it by his type
  Object _getTypedParam(
    final ParameterMirror methodParam,
    final String value,
  ) {
    if (methodParam.type.reflectedType == int) {
      return int.parse(value);
    } else if (methodParam.type.reflectedType == double) {
      return double.parse(value);
    } else if (methodParam.type.reflectedType == String) {
      return value;
    } else if (methodParam.type.reflectedType == bool) {
      return value == 'true';
    } else if (methodParam.type.reflectedType == Object) {
      return value;
    } else {
      throw ArgumentError.value(
          methodParam.type.reflectedType, 'methodParam.type.reflectedType');
    }
  }
}
