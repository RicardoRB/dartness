import 'package:dartness_server/dartness.dart';

part 'get_controller_class.g.dart';

@Controller("/get")
class GetControllerClass {
  static final GetControllerClass instance = GetControllerClass();

  @Get("/argument_error")
  getArgumentException() {
    throw ArgumentError('Random exception');
  }

  @Get("/range_error")
  getRangeError() {
    throw RangeError('Random exception');
  }
}
