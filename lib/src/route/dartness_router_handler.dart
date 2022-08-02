import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:shelf_plus/shelf_plus.dart';

import '../bind/annotation/body.dart';
import '../bind/annotation/header.dart';
import '../bind/annotation/http_status.dart';
import '../bind/annotation/path_param.dart';
import '../bind/annotation/query_param.dart';
import '../exception/http_status_exception.dart';
import '../string_utils.dart';

/// A router handler for handling request for a [ClassMirror] with [Controller]
/// with his metadata and the method [MethodMirror] with the metadata.
class DartnessRouterHandler {
  final ClassMirror _clazzMirror;
  final MethodMirror _methodMirror;

  DartnessRouterHandler(this._clazzMirror, this._methodMirror);

  /// Handles the route's response and invoke the [_methodMirror] in [_clazzMirror]
  Future<Response> handleRoute(final Request request,
      [final Object? extras]) async {
    final Map<String, String> pathParams = Map.of(request.params)
      ..removeWhere((key, value) {
        return request.url.queryParameters.containsKey(key);
      });

    final Map<String, Object> allParamsWithValue = {};
    if (pathParams.isNotEmpty) {
      final pathParamValues = _getPathParamsValues(_methodMirror, pathParams);
      allParamsWithValue.addAll(pathParamValues);
    }
    if (request.url.queryParameters.isNotEmpty) {
      final queryParamValues =
          _getQueryParamsValues(_methodMirror, request.url.queryParameters);
      allParamsWithValue.addAll(queryParamValues);
    }

    final List<dynamic> positionalArguments = [];
    final Map<Symbol, dynamic> namedArguments = {};
    for (final parameter in _methodMirror.parameters) {
      final paramName = MirrorSystem.getName(parameter.simpleName);

      if (allParamsWithValue.containsKey(paramName)) {
        if (parameter.isNamed) {
          namedArguments[parameter.simpleName] = allParamsWithValue[paramName];
        } else {
          positionalArguments.add(allParamsWithValue[paramName]);
        }
      } else {
        if (parameter.isOptional) {
          positionalArguments.add(null);
        }

        if (parameter.isNamed) {
          if (parameter.hasDefaultValue) {
            namedArguments[parameter.simpleName] =
                parameter.defaultValue?.reflectee;
          } else {
            namedArguments[parameter.simpleName] = null;
          }
        }
      }
      final containsBodyAnnotation = parameter.metadata.any((metadata) {
        return metadata.reflectee is Body;
      });
      if (containsBodyAnnotation) {
        final bodyReflectedClass = reflectClass(parameter.type.reflectedType);
        // Deserialize the body to the correct type and create an instance of it.
        final deserialized = await request.body.as(
          (reviver) {
            return bodyReflectedClass
                .newInstance(Symbol('fromJson'), [reviver]);
          },
        );
        positionalArguments.add(deserialized.reflectee);
      }

      final containsRequestClass = parameter.type.reflectedType == Request;
      if (containsRequestClass) {
        positionalArguments.add(request);
      }
    }

    final HttpCode? httpStatus = _methodMirror.metadata
        .firstWhereOrNull((meta) => meta.reflectee is HttpCode)
        ?.reflectee;

    final responseStatusCode = httpStatus?.code ?? HttpStatus.ok;

    final Iterable<Header> responseHeaders = _methodMirror.metadata
        .where((meta) => meta.reflectee is Header)
        .map((e) => e.reflectee);

    final Map<String, Object> headers = Map.fromIterable(
      responseHeaders,
      key: (e) => e.key,
      value: (e) => e.value,
    );

    try {
      final response = _clazzMirror.invoke(
        _methodMirror.simpleName,
        positionalArguments,
        namedArguments,
      );

      final result = response.reflectee;
      final dynamic body;
      if (result is Response) {
        return result;
      } else if (result is Future) {
        body = await result;
      } else if (result is Iterable || result is Map || result is Object) {
        body = jsonEncode(result);
      } else {
        body = result;
      }

      return Response(
        responseStatusCode,
        body: body,
        headers: headers,
      );
    } on HttpStatusException catch (e) {
      return Response(
        e.statusCode,
        body: e.message,
      );
    }
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

  /// Returns the values of the [methodPathParams] parameters based on the [pathParams]
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

  /// Gets the [method] parameters values from the [queryParameters].
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

  /// Returns the param value by the [methodParam] and the map [params]
  String _getParamValue(
    final ParameterMirror methodParam,
    final Map<String, String> params,
  ) {
    final defaultName = MirrorSystem.getName(methodParam.simpleName);
    final methodParamsByNameField =
        methodParam.metadata.firstWhereOrNull((element) {
      return element.reflectee.runtimeType == PathParam ||
          element.reflectee.runtimeType == QueryParam;
    });

    final String paramName;
    // If the param is annotated with @PathParam or @QueryParam,
    // use the field 'name' if it is not null otherwise use the variable name
    if (methodParamsByNameField != null) {
      paramName = _getParamNameByField(
        "name",
        methodParamsByNameField,
        orElse: defaultName,
      );
    } else {
      paramName = defaultName;
    }

    final value = params[paramName];
    if (value == null) {
      throw ArgumentError.value(methodParam, 'methodParam',
          'missing parameter ${methodParam.simpleName}');
    }
    return value;
  }

  /// Returns the value of a field with [fieldName] that [mirror] contains or
  /// returns [orElse] if it is null
  String _getParamNameByField(
    final String fieldName,
    final InstanceMirror mirror, {
    required String orElse,
  }) {
    final nameFieldSymbol = MirrorSystem.getSymbol(fieldName);
    final paramName = mirror.getField(nameFieldSymbol).reflectee ?? orElse;
    return paramName;
  }

  /// Gets the value param from the [methodParam] checking his type
  /// and returns the [value] by his real type
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
    } else if (methodParam.type.reflectedType == List<int>) {
      return stringToIterableInt(value).toList();
    } else if (methodParam.type.reflectedType == List<double>) {
      return stringToIterableDouble(value).toList();
    } else if (methodParam.type.reflectedType == List<bool>) {
      return stringToIterableBool(value).toList();
    } else if (methodParam.type.reflectedType == List<String>) {
      return stringToIterableString(value).toList();
    } else if (methodParam.type.reflectedType == List<Object>) {
      return stringToIterableString(value).toList();
    } else if (methodParam.type.reflectedType == Set<int>) {
      return stringToIterableInt(value).toSet();
    } else if (methodParam.type.reflectedType == Set<double>) {
      return stringToIterableDouble(value).toSet();
    } else if (methodParam.type.reflectedType == Set<bool>) {
      return stringToIterableBool(value).toSet();
    } else if (methodParam.type.reflectedType == Set<String>) {
      return stringToIterableString(value).toSet();
    } else if (methodParam.type.reflectedType == Set<Object>) {
      return stringToIterableString(value).toSet();
    } else if (methodParam.type.reflectedType == Object) {
      return value;
    } else {
      throw ArgumentError.value(
          methodParam.type.reflectedType, 'methodParam.type.reflectedType');
    }
  }
}
