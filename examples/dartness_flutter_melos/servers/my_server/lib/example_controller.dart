import 'package:dartness_server/bind/annotation/controller.dart';
import 'package:dartness_server/bind/annotation/get.dart';

@Controller("/hello")
class ExampleController {
  @Get("/world")
  static String getHelloWorld() {
    return "Hello Wold";
  }
}
