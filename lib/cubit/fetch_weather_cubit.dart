// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/model/weather.dart';

import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/repository/supabase_repository.dart';
import 'package:weather_app/repository/weather_repository.dart';

//states
class WeatherState {}

class WeatherSuccessState<T> extends WeatherState {
  final T item;

  WeatherSuccessState({required this.item});
}

class WeatherErrorState extends WeatherState {
  final String? message;

  WeatherErrorState({required this.message});
}

class WeatherLoadingState extends WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherEmptyState extends WeatherState {}

//cubit
class FetchWeatherCubit extends Cubit<WeatherState> {
  LocationRepository locationRepository;
  WeatherRepository weatherRepository;
  SupabaseRepository supabaseRepository;
  FetchWeatherCubit(
      {required this.locationRepository,
      required this.weatherRepository,
      required this.supabaseRepository})
      : super(WeatherInitialState());

  fetchWeather() async {
    emit(WeatherLoadingState());

    //get postion
    final locRes = await locationRepository.getPosition();
    locRes.fold(
      (err) {
        emit(WeatherErrorState(message: err));
      },

      //use position to fetch cityName for weather model, and to fetch weatherdata
      (position) async {
        final cityName =
            await locationRepository.getCityName(position: position);
        final weatherRes = await weatherRepository.fetchWeatherData(
            lat: position.latitude,
            lon: position.longitude,
            cityName: cityName);
        weatherRes.fold(
          (err) {
            emit(WeatherErrorState(message: err));
          },
          (data) {
            emit(WeatherSuccessState<Weather>(item: data));
          },
        );
      },
    );
  }

  fetchWeatherBySearch({
    required double lat,
    required double lon,
    required String cityName,
  }) async {
    emit(WeatherLoadingState());
    final weatherRes = await weatherRepository.fetchWeatherData(
      lat: lat,
      lon: lon,
      cityName: cityName,
    );
    weatherRes.fold(
      (err) {
        emit(WeatherErrorState(message: err));
      },
      (data) {
        emit(WeatherSuccessState<Weather>(item: data));
      },
    );
  }

  fetchWeatherByCityName({
    required String cityName,
  }) async {
    emit(WeatherLoadingState());
    final supaRes = await supabaseRepository.findCity(query: cityName);
    supaRes.fold(
      (err) {
        emit(WeatherErrorState(message: err));
      },
      (data) async {
        final weatherRes = await weatherRepository.fetchWeatherData(
          lat: data["lat"],
          lon: data["lon"],
          cityName: data["cityName"],
        );
        weatherRes.fold(
          (err) {
            emit(WeatherErrorState(message: err));
          },
          (data) {
            emit(WeatherSuccessState<Weather>(item: data));
          },
        );
      },
    );
  }

  clearData() {
    emit(WeatherEmptyState());
  }
}
