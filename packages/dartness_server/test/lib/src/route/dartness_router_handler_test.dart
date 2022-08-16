// import 'dart:convert';
// import 'dart:io';
// import 'dart:mirrors';
//
// import 'package:dartness_server/dartness.dart';
// import 'package:dartness_server/route.dart';
// import 'package:shelf/shelf.dart';
// import 'package:shelf_plus/shelf_plus.dart';
// import 'package:test/test.dart';
//
// void main() {
//   late DartnessRouterHandler dartnessRouterHandler;
//   late ClassMirror clazzMirror;
//   late TestController testController;
//
//   setUp(() async {
//     testController = TestController();
//     clazzMirror = reflectClass(testController.runtimeType);
//   });
//
//   MethodMirror _getMethodMirror(
//     final String methodName, {
//     final List<String> params = const [],
//   }) {
//     final methodMirror = clazzMirror.declarations.values
//         .where((value) => value is MethodMirror && value.isRegularMethod)
//         .map((method) => method as MethodMirror)
//         .firstWhere((element) {
//       bool hasSameParameters = true;
//       if (element.parameters.length != params.length) {
//         hasSameParameters = false;
//       } else {
//         for (int i = 0; i < element.parameters.length; i++) {
//           final name = MirrorSystem.getName(element.parameters[i].simpleName);
//           if (name != params[i]) {
//             hasSameParameters = false;
//             break;
//           }
//         }
//       }
//       return MirrorSystem.getName(element.simpleName) == methodName &&
//           hasSameParameters;
//     });
//     return methodMirror;
//   }
//
//   test("Getting double", () async {
//     final methodMirror = _getMethodMirror('getDouble');
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = '1.1';
//     final request = Request(
//         "GET",
//         Uri(
//           scheme: "http",
//           host: "localhost",
//           port: 8080,
//           path: "test/double",
//         ));
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
//
//   test("Getting null", () async {
//     final methodMirror = _getMethodMirror('getNull');
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = '';
//     final request = Request(
//         "GET",
//         Uri(
//           scheme: "http",
//           host: "localhost",
//           port: 8080,
//           path: "test/null",
//         ));
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
//
//   test("Getting object", () async {
//     final methodMirror = _getMethodMirror('getClass');
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = jsonEncode(Foo('class'));
//     final request = Request(
//         "GET",
//         Uri(
//           scheme: "http",
//           host: "localhost",
//           port: 8080,
//           path: "test/class",
//         ));
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
//
//   test("Getting future", () async {
//     final methodMirror = _getMethodMirror('getFuture');
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = 'bla';
//     final request = Request(
//         "GET",
//         Uri(
//           scheme: "http",
//           host: "localhost",
//           port: 8080,
//           path: "test/future",
//         ));
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
//
//   test("Getting paths", () async {
//     final methodMirror = _getMethodMirror('getParam', params: ['id']);
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = '1';
//     final Map<String, String> pathParams = {'id': '1'};
//     final request = Request(
//       "GET",
//       Uri(
//         scheme: "http",
//         host: "localhost",
//         port: 8080,
//         path: "ids/1",
//       ),
//       context: {
//         'shelf_router/params': pathParams,
//       },
//     );
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
//
//   test("Getting query", () async {
//     final methodMirror = _getMethodMirror('getQuery', params: ['id']);
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = '1';
//     final request = Request(
//       "GET",
//       Uri(
//         scheme: "http",
//         host: "localhost",
//         port: 8080,
//         path: "query",
//         queryParameters: {'id': '1'},
//       ),
//     );
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
//
//   test("Getting query", () async {
//     final methodMirror = _getMethodMirror('getQueries', params: ['id', 'id2']);
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = '"1/2"';
//     final request = Request(
//       "GET",
//       Uri(
//         scheme: "http",
//         host: "localhost",
//         port: 8080,
//         path: "queries",
//         queryParameters: {'id': '1', 'id2': '2'},
//       ),
//     );
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
//
//   test("Getting query", () async {
//     final methodMirror = _getMethodMirror('getQueries', params: ['id', 'id2']);
//     dartnessRouterHandler = DartnessRouterHandler(testController, methodMirror);
//     final expectedStatusCode = HttpStatus.ok;
//     final expectedBody = '"1/2"';
//     final request = Request(
//       "GET",
//       Uri(
//         scheme: "http",
//         host: "localhost",
//         port: 8080,
//         path: "queries",
//         queryParameters: {'id': '1', 'id2': '2'},
//       ),
//     );
//     final result = await dartnessRouterHandler.handler(request, null);
//     expect(result.statusCode, equals(expectedStatusCode));
//     expect(await result.readAsString(), equals(expectedBody));
//   });
// }
//
// @Controller("/test")
// class TestController {
//   @Bind.get("/double")
//   double getDouble() {
//     return 1.1;
//   }
//
//   @Bind.get("/null")
//   dynamic getNull() {
//     return null;
//   }
//
//   @Bind.get("/class")
//   Foo getClass() {
//     return Foo('class');
//   }
//
//   @Bind.get("/future")
//   Future<String> getFuture() async {
//     return Future.value("bla");
//   }
//
//   @Bind.get("/ids/<id>")
//   int getParam(@PathParam() int id) {
//     return id;
//   }
//
//   @Bind.get("/query")
//   int getQuery(@QueryParam() int id) {
//     return id;
//   }
//
//   @Bind.get("/queries")
//   String getQueries(
//     @QueryParam() int id,
//     @QueryParam() int id2,
//   ) {
//     return '$id/$id2';
//   }
//
//   @Bind.get("/paths/<id>")
//   String getPaths(
//     @PathParam() int id,
//     @QueryParam() int query,
//   ) {
//     return '$id/$query';
//   }
//
//   @Bind.get("/paths/<path1>/another/<path2>")
//   String getPathsAnotherPaths(
//     @PathParam() int path1,
//     @QueryParam() int query,
//     @PathParam() int path2,
//     @QueryParam() int query2,
//   ) {
//     return '$path1/$path2/$query/$query2';
//   }
//
//   @Bind.get("/types")
//   String getTypes(
//     @QueryParam() bool bool,
//     @QueryParam() int int,
//     @QueryParam() double double,
//     @QueryParam() String string,
//     @QueryParam() List<int> list,
//   ) {
//     return '$bool/$int/$double/$string/$list';
//   }
//
//   @Bind.get("/names/<namePath>")
//   String getNames(
//     @PathParam("namePath") String otherPath,
//     @QueryParam("nameQuery") String otherQuery,
//   ) {
//     return '$otherPath/$otherQuery';
//   }
//
//   @HttpCode(HttpStatus.accepted)
//   @Bind.get("/statuscodes")
//   getStatusCode() {}
//
//   @Header('test', 'test')
//   @Bind.get("/headers")
//   getHeader() {}
// }
//
// class Foo {
//   const Foo(this.value);
//
//   final String value;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'value': value,
//     };
//   }
//
//   Foo.fromJson(Map<String, dynamic> json) : value = json['value'];
// }
