import 'package:dartness_server/route.dart';

import 'foo.dart';

part 'delete_controller_class.g.dart';

@Controller("/delete")
class DeleteControllerClass {
  static final DeleteControllerClass instance = DeleteControllerClass();

  @Delete("/double")
  double deleteDouble() {
    return 1.1;
  }

  @Delete("/null")
  dynamic deleteNull() {
    return null;
  }

  @Delete("/class")
  Foo deleteClass() {
    return Foo('class');
  }

  @Delete("/future")
  Future<String> deleteFuture() async {
    return Future.value("bla");
  }

  @Delete("/ids/<id>")
  int deleteParam(int id) {
    return id;
  }
}
