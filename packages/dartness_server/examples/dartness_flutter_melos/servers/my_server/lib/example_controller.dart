import 'package:dartness_server/http_method.dart';

@Controller("/hello")
class ExampleController {
  @Bind.get("/world")
  static String getHelloWorld() {
    return "Hello Wold";
  }
}
