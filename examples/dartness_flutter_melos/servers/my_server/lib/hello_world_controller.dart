import 'package:dartness_server/route.dart';

part 'hello_world_controller.g.dart';

@Controller("/hello")
class ExampleController {
  @Get("/world")
  String getHelloWorld() {
    return "Hello Wold";
  }
}
