class CityDto {
  CityDto(this.name);

  final String name;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
