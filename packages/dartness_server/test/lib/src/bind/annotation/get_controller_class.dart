import 'dart:io';

import 'package:dartness_server/dartness.dart';

import 'foo.dart';

part 'get_controller_class.g.dart';

@Controller("/get")
class GetControllerClass {
  static final GetControllerClass instance = GetControllerClass();

  @Get("/double")
  double getDouble() {
    return 1.1;
  }

  @Get("/null")
  dynamic getNull() {
    return null;
  }

  @Get("/class")
  Foo getClass() {
    return Foo('class');
  }

  @Get("/future")
  Future<String> getFuture() async {
    return Future.value("bla");
  }

  @Get("/ids/<id>")
  int getParam(@PathParam() int id) {
    return id;
  }

  @Get("/query")
  int getQuery(@QueryParam() int id) {
    return id;
  }

  @Get("/queries")
  String getQueries(
    @QueryParam() int id,
    @QueryParam() int id2,
  ) {
    return '$id/$id2';
  }

  @Get("/paths/<id>")
  String getPaths(
    @PathParam() int id,
    @QueryParam() int query,
  ) {
    return '$id/$query';
  }

  @Get("/paths/<path1>/another/<path2>")
  String getPathsAnotherPaths(
    @PathParam() int path1,
    @QueryParam() int query,
    @PathParam() int path2,
    @QueryParam() int query2,
  ) {
    return '$path1/$path2/$query/$query2';
  }

  @Get("/types")
  String getTypes(
    @QueryParam() bool bool,
    @QueryParam() int int,
    @QueryParam() double double,
    @QueryParam() String string,
    @QueryParam() List<int> list,
  ) {
    return '$bool/$int/$double/$string/$list';
  }

  @Get("/optional")
  String getOptional(
    @QueryParam() bool? bool, {
    @QueryParam() int int = 1,
  }) {
    return '$bool/$int';
  }

  @Get("/names/<namePath>")
  String getNames(
    @PathParam("namePath") String otherPath,
    @QueryParam("nameQuery") String otherQuery,
  ) {
    return '$otherPath/$otherQuery';
  }

  @HttpCode(HttpStatus.accepted)
  @Get("/statuscodes")
  getStatusCode() {}

  @Header('test', 'test')
  @Get("/headers")
  getHeader() {}
}
