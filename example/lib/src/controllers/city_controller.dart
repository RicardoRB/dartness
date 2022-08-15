import 'package:dartness_server/dartness.dart';
import 'package:shelf/shelf.dart';

import '../services/city_service.dart';

part 'city_controller.g.dart';

@Controller('/cities')
class CityController {
  const CityController(this._cityService);

  final CityService _cityService;

  @Get()
  Response getCities(Request request) {
    return Response.ok(_cityService.getCities());
  }

  @Get('/<id>')
  String getCity(@PathParam() int id) {
    return _cityService.getCity(id);
  }
}
