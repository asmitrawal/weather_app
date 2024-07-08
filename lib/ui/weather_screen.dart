import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/fetch_weather_cubit.dart';
import 'package:weather_app/cubit/search_city_cubit.dart';
import 'package:weather_app/repository/location_repository.dart';
import 'package:weather_app/repository/supabase_repository.dart';
import 'package:weather_app/repository/weather_repository.dart';
import 'package:weather_app/ui/weather_widget.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchWeatherCubit(
            locationRepository: context.read<LocationRepository>(),
            weatherRepository: context.read<WeatherRepository>(),
            supabaseRepository: context.read<SupabaseRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              SearchCityCubit(repository: context.read<SupabaseRepository>()),
        ),
      ],
      child: WeatherWidget(),
    );
  }
}
