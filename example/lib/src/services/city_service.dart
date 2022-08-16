import '../dto/city_dto.dart';

class CityService {
  final cities = ['New York', 'London', 'Paris'];

  List<String> getCities() {
    return cities;
  }

  CityDto getCity(int id) {
    return CityDto(cities[id]);
  }
}
