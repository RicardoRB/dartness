import '../dto/city_dto.dart';

class CityService {
  final cities = ['New York', 'London', 'Paris'];

  List<String> getCities([int? offset]) {
    if (offset != null) {
      return cities.skip(offset).toList();
    }
    return cities;
  }

  CityDto getCity(int id) {
    return CityDto(cities[id]);
  }
}
