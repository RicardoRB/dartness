import 'dart:convert';

import 'package:shelf_plus/shelf_plus.dart';

import '../exception/http_status_exception.dart';

typedef OnCall = dynamic Function(List arguments);

/// A router handler for handling request for a [_controller]
/// with his metadata and the method [MethodMirror] with the metadata.
class DartnessRouterHandler {
  DartnessRouterHandler(
    this._methodFunction,
    this.positionalArguments,
    this.namedArguments,
  );

  final Function _methodFunction;
  final List<String> positionalArguments;
  final Map<String, dynamic>? namedArguments;

  /// Handles the route's response and invoke the [_methodMirror] in [_controller]
  Future<Response> handleRoute(final Request request,
      [final Object? extras]) async {
    try {
      final arguments = request.params.entries
          .where((e) => positionalArguments.contains(e.key))
          .map((e) => _getTypedParam(e.value))
          .toList();
      final Map<Symbol, dynamic> namedArguments = {};
      final response =
          await Function.apply(_methodFunction, arguments, namedArguments);

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
        200,
        body: body,
      );
    } on HttpStatusException catch (e) {
      return Response(
        e.statusCode,
        body: e.message,
      );
    }
  }

  /// Gets the value param from the [methodParam] checking his type
  /// and returns the [value] by his real type
  Object _getTypedParam(final String value) {
    if (num.tryParse(value) != null) {
      if (int.tryParse(value) != null) {
        return int.parse(value);
      } else {
        return double.parse(value);
      }
    } else if (value == 'true' || value == 'false') {
      return value == 'true';
    } else {
      return value;
    }
  }
}
