import 'package:dartness_server/bind.dart';

import '../service/city_service.dart';

part 'city_controller.g.dart';

@Controller('/cities')
class CityController {
  final CityService _cityService;

  CityController(this._cityService);

  @Get()
  List<String> getCities() {
    return _cityService.getCities();
  }
}
