import 'package:dartness_server/bind.dart';

@Controller("/hello")
class ExampleController {
  @Get("/world")
  static String getHelloWorld() {
    return "Hello Wold";
  }
}
