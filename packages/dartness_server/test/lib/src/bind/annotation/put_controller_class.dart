import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/route.dart';

import 'foo.dart';

part 'put_controller_class.g.dart';

@Controller("/put")
class PutControllerClass {
  static final PutControllerClass instance = PutControllerClass();

  @Put("/double")
  double putDouble() {
    return 1.1;
  }

  @Put("/null")
  dynamic putNull() {
    return null;
  }

  @Put("/class")
  Foo putClass() {
    return Foo('class');
  }

  @Put("/future")
  Future<String> putFuture() async {
    return Future.value("bla");
  }

  @Put("/ids/<id>")
  int putParam(@PathParam() int id) {
    return id;
  }
}
