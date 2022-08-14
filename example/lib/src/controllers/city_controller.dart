import 'package:dartness_server/dartness.dart';

import '../services/city_service.dart';

part 'city_controller.g.dart';

@Controller('/cities')
class CityController {
  CityController(this._cityService);

  final CityService _cityService;

  @Get()
  List<String> getCities() {
    return _cityService.getCities();
  }

  @Get('/:id')
  String getCity(@PathParam() String id) {
    return _cityService.getCity(id);
  }
}
