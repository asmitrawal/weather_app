// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/fetch_weather_cubit.dart';
import 'package:weather_app/cubit/search_city_cubit.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  CustomSearchBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 30,
        bottom: 5,
        right: 30,
        top: 20,
      ),
      child: TextField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search your city",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear_rounded),
            onPressed: () {
              context.read<SearchCityCubit>().emptySuggestions();
              controller.clear();
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        onSubmitted: (value) {
          context.read<FetchWeatherCubit>().fetchWeatherByCityName(cityName: value);
          controller.clear();
        },
      ),
    );
  }
}
