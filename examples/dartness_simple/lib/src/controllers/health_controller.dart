import 'dart:io';

import 'package:dartness_server/route.dart';

part 'health_controller.g.dart';

@Controller('/health')
@Header(HttpHeaders.contentTypeHeader, 'application/json')
class HealthController {
  @HttpCode(202)
  @Get()
  bool getAlive() {
    return true;
  }
}
