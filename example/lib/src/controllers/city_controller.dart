import 'package:dartness_server/dartness.dart';
import 'package:example/src/dto/city_dto.dart';

import '../services/city_service.dart';

part 'city_controller.g.dart';

@Controller('/cities')
class CityController {
  CityController(this._cityService);

  final CityService _cityService;

  @HttpMethod.get()
  List<String> getCities({
    @QueryParam() int? offset,
  }) {
    return _cityService.getCities(offset);
  }

  @HttpMethod.get('/<id>')
  CityDto getCity(@PathParam() int id) {
    return _cityService.getCity(id);
  }
}
