import 'package:dartness_server/src/route/route.dart';

import 'foo.dart';

part 'post_controller_class.g.dart';

@Controller("/post")
class PostControllerClass {
  static final PostControllerClass instance = PostControllerClass();

  @Post("/double")
  double postDouble() {
    return 1.1;
  }

  @Post("/null")
  dynamic postNull() {
    return null;
  }

  @Post("/class")
  Foo postClass() {
    return Foo('class');
  }

  @Post("/future")
  Future<String> postFuture() async {
    return Future.value("bla");
  }

  @Post("/ids/<id>")
  int postParam(@PathParam() int id) {
    return id;
  }

  @Post("/body")
  Foo postBody(@Body() Foo body) {
    return body;
  }
}
