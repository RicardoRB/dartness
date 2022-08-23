import 'dart:io';

import 'package:dartness_server/dartness.dart';
import 'package:dartness_server/route.dart';

import '../dtos/city_dto.dart';
import '../services/city_service.dart';

part 'city_controller.g.dart';

@Controller('/cities')
class CityController {
  CityController(this._cityService);

  final CityService _cityService;

  @HttpCode(202)
  @Get()
  List<String> getCities({
    @QueryParam() int? offset = 100,
  }) {
    return _cityService.getCities(offset);
  }

  @Header(HttpHeaders.contentTypeHeader, 'application/json')
  @Get('/<id>')
  CityDto getCity(@PathParam() int id) {
    return _cityService.getCity(id);
  }
}
