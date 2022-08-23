import '../dtos/city_dto.dart';
import '../error_handlers/not_found_exception.dart';

class CityService {
  final cities = ['New York', 'London', 'Paris'];

  List<String> getCities([int? offset]) {
    if (offset != null) {
      return cities.skip(offset).toList();
    }
    return cities;
  }

  CityDto getCity(int id) {
    if (id > cities.length) {
      throw NotFoundException('City not found');
    }
    return CityDto(cities[id]);
  }
}
