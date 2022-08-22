import 'package:dartness_server/dartness.dart';

import 'example_custom_http_status_exception.dart';

part 'get_controller_class.g.dart';

@Controller("/get")
class GetControllerClass {
  static final GetControllerClass instance = GetControllerClass();

  @Get("/custom_exception")
  getCustomException() {
    throw ExampleCustomHttpStatusException('Custom exception thrown');
  }
}
