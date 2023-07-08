import 'package:dartness_server/src/route/route.dart';

part 'class_controller.g.dart';

@Controller("/")
class ClassController {
  static final ClassController instance = ClassController();

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
