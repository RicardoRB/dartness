import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:dartness_server/dartness.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_plus/shelf_plus.dart';
import 'package:test/test.dart';

void main() {
  late DartnessRouterHandler dartnessRouterHandler;
  final clazzMirror = reflectClass(TestController);

  MethodMirror _getMethodMirror(
    final String methodName, {
    final List<String> params = const [],
  }) {
    final methodMirror = clazzMirror.declarations.values
        .where((value) => value is MethodMirror && value.isRegularMethod)
        .map((method) => method as MethodMirror)
        .firstWhere((element) {
      bool hasSameParameters = true;
      if (element.parameters.length != params.length) {
        hasSameParameters = false;
      } else {
        for (int i = 0; i < element.parameters.length; i++) {
          final name = MirrorSystem.getName(element.parameters[i].simpleName);
          if (name != params[i]) {
            hasSameParameters = false;
            break;
          }
        }
      }
      return MirrorSystem.getName(element.simpleName) == methodName &&
          hasSameParameters;
    });
    return methodMirror;
  }

  test("Getting double", () async {
    final methodMirror = _getMethodMirror('getDouble');
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = '1.1';
    final request = Request(
        "GET",
        Uri(
          scheme: "http",
          host: "localhost",
          port: 8080,
          path: "test/double",
        ));
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });

  test("Getting null", () async {
    final methodMirror = _getMethodMirror('getNull');
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = '';
    final request = Request(
        "GET",
        Uri(
          scheme: "http",
          host: "localhost",
          port: 8080,
          path: "test/null",
        ));
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });

  test("Getting object", () async {
    final methodMirror = _getMethodMirror('getClass');
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = jsonEncode(Foo('class'));
    final request = Request(
        "GET",
        Uri(
          scheme: "http",
          host: "localhost",
          port: 8080,
          path: "test/class",
        ));
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });

  test("Getting future", () async {
    final methodMirror = _getMethodMirror('getFuture');
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = 'bla';
    final request = Request(
        "GET",
        Uri(
          scheme: "http",
          host: "localhost",
          port: 8080,
          path: "test/future",
        ));
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });

  test("Getting paths", () async {
    final methodMirror = _getMethodMirror('getParam', params: ['id']);
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = '1';
    final Map<String, String> pathParams = {'id': '1'};
    final request = Request(
      "GET",
      Uri(
        scheme: "http",
        host: "localhost",
        port: 8080,
        path: "ids/1",
      ),
      context: {
        'shelf_router/params': pathParams,
      },
    );
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });

  test("Getting query", () async {
    final methodMirror = _getMethodMirror('getQuery', params: ['id']);
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = '1';
    final request = Request(
      "GET",
      Uri(
        scheme: "http",
        host: "localhost",
        port: 8080,
        path: "query",
        queryParameters: {'id': '1'},
      ),
    );
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });

  test("Getting query", () async {
    final methodMirror = _getMethodMirror('getQueries', params: ['id', 'id2']);
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = '"1/2"';
    final request = Request(
      "GET",
      Uri(
        scheme: "http",
        host: "localhost",
        port: 8080,
        path: "queries",
        queryParameters: {'id': '1', 'id2': '2'},
      ),
    );
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });

  test("Getting query", () async {
    final methodMirror = _getMethodMirror('getQueries', params: ['id', 'id2']);
    dartnessRouterHandler = DartnessRouterHandler(clazzMirror, methodMirror);
    final expectedStatusCode = HttpStatus.ok;
    final expectedBody = '"1/2"';
    final request = Request(
      "GET",
      Uri(
        scheme: "http",
        host: "localhost",
        port: 8080,
        path: "queries",
        queryParameters: {'id': '1', 'id2': '2'},
      ),
    );
    final result = await dartnessRouterHandler.handleRoute(request, null);
    expect(result.statusCode, equals(expectedStatusCode));
    expect(await result.readAsString(), equals(expectedBody));
  });
}

@Controller("/test")
class TestController {
  @Get("/double")
  static double getDouble() {
    return 1.1;
  }

  @Get("/null")
  static dynamic getNull() {
    return null;
  }

  @Get("/class")
  static Foo getClass() {
    return Foo('class');
  }

  @Get("/future")
  static Future<String> getFuture() async {
    return Future.value("bla");
  }

  @Get("/ids/<id>")
  static int getParam(@PathParam() int id) {
    return id;
  }

  @Get("/query")
  static int getQuery(@QueryParam() int id) {
    return id;
  }

  @Get("/queries")
  static String getQueries(
    @QueryParam() int id,
    @QueryParam() int id2,
  ) {
    return '$id/$id2';
  }

  @Get("/paths/<id>")
  static String getPaths(
    @PathParam() int id,
    @QueryParam() int query,
  ) {
    return '$id/$query';
  }

  @Get("/paths/<path1>/another/<path2>")
  static String getPathsAnotherPaths(
    @PathParam() int path1,
    @QueryParam() int query,
    @PathParam() int path2,
    @QueryParam() int query2,
  ) {
    return '$path1/$path2/$query/$query2';
  }

  @Get("/types")
  static String getTypes(
    @QueryParam() bool bool,
    @QueryParam() int int,
    @QueryParam() double double,
    @QueryParam() String string,
    @QueryParam() List<int> list,
  ) {
    return '$bool/$int/$double/$string/$list';
  }

  @Get("/names/<namePath>")
  static String getNames(
    @PathParam("namePath") String otherPath,
    @QueryParam("nameQuery") String otherQuery,
  ) {
    return '$otherPath/$otherQuery';
  }

  @HttpCode(HttpStatus.accepted)
  @Get("/statuscodes")
  static getStatusCode() {}

  @Header('test', 'test')
  @Get("/headers")
  static getHeader() {}
}

class Foo {
  const Foo(this.value);

  final String value;

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }

  Foo.fromJson(Map<String, dynamic> json) : value = json['value'];
}
