class Weather {
  final String cityName;
  final String weatherCondition;
  final double temp;

  Weather(
      {required this.cityName,
      required this.weatherCondition,
      required this.temp});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json["cityName"],
        weatherCondition: json["weatherCondition"],
        temp: json["temp"]);
  }
}
