// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_controller_class.dart';

// **************************************************************************
// ControllerGenerator
// **************************************************************************

extension PostControllerClassRoutes on PostControllerClass {
  List<ControllerRoute> getRoutes() {
    final routes = <ControllerRoute>[];
    routes.add(ControllerRoute(
      method: 'POST',
      path: '/post/double',
      handler: postDouble,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'POST',
      path: '/post/null',
      handler: postNull,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'POST',
      path: '/post/class',
      handler: postClass,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'POST',
      path: '/post/future',
      handler: postFuture,
      params: [],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'POST',
      path: '/post/ids/<id>',
      handler: postParam,
      params: [
        DartnessParam(
          name: 'id',
          isQuery: false,
          isPath: true,
          isBody: false,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: int,
          defaultValue: null,
          fromJson: null,
        )
      ],
      httpCode: null,
      headers: {},
    ));
    routes.add(ControllerRoute(
      method: 'POST',
      path: '/post/body',
      handler: postBody,
      params: [
        DartnessParam(
          name: 'body',
          isQuery: false,
          isPath: false,
          isBody: true,
          isNamed: false,
          isPositional: true,
          isOptional: false,
          type: Foo,
          defaultValue: null,
          fromJson: Foo.fromJson,
        )
      ],
      httpCode: null,
      headers: {},
    ));
    return routes;
  }
}

class PostDartnessControllerClass extends DartnessController {
  PostDartnessControllerClass(PostControllerClass controller)
      : super(
          controller,
          controller.getRoutes(),
        );
}
