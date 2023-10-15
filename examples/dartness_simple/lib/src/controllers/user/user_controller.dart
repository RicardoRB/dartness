import 'dart:io';

import 'package:dartness_server/route.dart';

part 'user_controller.g.dart';

@Controller('/users')
@Header(HttpHeaders.contentTypeHeader, 'application/json')
class UserController {
  @HttpCode(202)
  @Get()
  List<String> getCities({
    @QueryParam() int? offset,
  }) {
    return ['user1', 'user2'];
  }
}
