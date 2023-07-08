import 'package:dartness_server/src/route/route.dart';

part 'test_controller.g.dart';

@Controller("/auth")
class TestController {
  static final TestController instance = TestController();

  @Get()
  String get() => '';

  @Get("/error")
  String getError() => throw Exception("random exception");
}
