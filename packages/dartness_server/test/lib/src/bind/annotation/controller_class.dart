import 'package:dartness_server/dartness.dart';

part 'controller_class.g.dart';

@Controller("/")
class ControllerClass {
  static final ControllerClass instance = ControllerClass();

  @Get()
  String getEmpty() {
    return "Empty";
  }

  @Post()
  String postEmpty() {
    return "Empty";
  }

  @Put()
  String putEmpty() {
    return "Empty";
  }

  @Delete()
  String deleteEmpty() {
    return "Empty";
  }
}
