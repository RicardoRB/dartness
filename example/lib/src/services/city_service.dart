class CityService {
  final cities = ['New York', 'London', 'Paris'];

  List<String> getCities() {
    return cities;
  }

  String getCity(int id) {
    return cities[id];
  }
}
