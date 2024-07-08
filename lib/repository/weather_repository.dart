import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather.dart';

class WeatherRepository {
  static const API_KEY = "62b3fefb1156b7370d25ce996d5187b4";

  Future<Either<String, Weather>> fetchWeatherData(
      {required double lat,
      required double lon,
      required String cityName}) async {
    final res = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${API_KEY}"),
    );
    if (res.statusCode == 200) {
      final result = jsonDecode(res.body);
      final weather = Weather(
        cityName: cityName,
        weatherCondition: result["weather"][0]["main"],
        temp: (result["main"]["temp"] - 273.15) as double,
      );
      return Right(weather);
    } else {
      return Left("Error fetching weather data");
    }
  }
}
