import 'dart:convert';
import 'dart:mirrors';

import 'package:dartness/bind/bind_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class GetHandler implements BindHandler {
  @override
  Function handle(
      final ClassMirror clazzDeclaration, final MethodMirror method) {
    return (final Request request) async {
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
    };
  }
}
