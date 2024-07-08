import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/components/custom_search_bar.dart';
import 'package:weather_app/components/custom_search_tile.dart';
import 'package:weather_app/cubit/fetch_weather_cubit.dart';
import 'package:weather_app/cubit/search_city_cubit.dart';
import 'package:weather_app/model/weather.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late TextEditingController _controller;
  Timer? debouncer;
  String? lastSearchText;
  searchWithDebounce({required String query}) {
    lastSearchText = query;
    debouncer = Timer(
      Duration(milliseconds: 500),
      () {
        context.read<SearchCityCubit>().searchCity(query: query);
      },
    );
  }

  String getAnimation({required weatherCondition}) {
    switch (weatherCondition) {
      case "Clouds":
        return 'assets/cloudy.json';
      case "Thunderstorm":
        return 'assets/thunder.json';
      case "Drizzle":
      case "Rain":
        return 'assets/rainy.json';
      case "Snow":
        return 'assets/snow.json';
      case "Atmosphere":
      case "Clear":
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(
      () {
        debouncer?.cancel();
        if (_controller.text.isNotEmpty) {
          if (_controller.text != lastSearchText) {
            searchWithDebounce(query: _controller.text);
          }
        } else {
          _controller.clear();
          context.read<SearchCityCubit>().emptySuggestions();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text(
          "Weather Gather",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //searchbar
          CustomSearchBar(
            controller: _controller,
          ),

          //current location weather button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 30),
                // color: Colors.white,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<FetchWeatherCubit>().fetchWeather();
                  },
                  child: Text("Fetch my weather"),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 30),
                child: IconButton(
                  onPressed: () {
                    context.read<FetchWeatherCubit>().clearData();
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                  ),
                ),
              ),
            ],
          ),

          Flexible(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  //weatherdata
                  BlocConsumer<FetchWeatherCubit, WeatherState>(
                    listener: (context, state) {
                      if (state is WeatherErrorState) {
                        context.read<SearchCityCubit>().emptySuggestions();
                      }
                      else if (state is WeatherSuccessState) {
                        context.read<SearchCityCubit>().emptySuggestions();
                      }
                    },
                    builder: (context, state) {
                      if (state is WeatherLoadingState) {
                        context.loaderOverlay.show();
                      } else {
                        context.loaderOverlay.hide();
                      }
                      if (state is WeatherSuccessState<Weather>) {
                        return Container(
                          alignment: Alignment.center,
                          color: Colors.blue[100],
                          margin: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 50),
                          padding: EdgeInsets.symmetric(vertical: 50),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                state.item.cityName,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Lottie.asset(
                                getAnimation(
                                  weatherCondition: state.item.weatherCondition,
                                ),
                              ),
                              Text(
                                state.item.weatherCondition,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${state.item.temp.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "°",
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is WeatherErrorState) {
                        return AlertDialog.adaptive(
                          content: Text(
                            state.message ?? "Error fetching data",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (state is WeatherEmptyState) {
                        return Center();
                      } else {
                        return Center();
                      }
                    },
                  ),

                  //suggestions listtile
                  BlocBuilder<SearchCityCubit, SearchState>(
                    builder: (context, state) {
                      if (state
                          is SearchSuccessState<List<Map<String, dynamic>>>) {
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 0);
                          },
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return CustomSearchTile(
                              cityName: "${state.item[index]["cityName"]}",
                              countryName: "${state.item[index]["country"]}",
                              onTap: () {
                                _controller.clear();

                                context
                                    .read<SearchCityCubit>()
                                    .emptySuggestions();
                                context
                                    .read<FetchWeatherCubit>()
                                    .fetchWeatherBySearch(
                                        lat: state.item[index]["lat"],
                                        lon: state.item[index]["lat"],
                                        cityName: state.item[index]
                                            ["cityName"]);
                              },
                            );
                          },
                          itemCount: state.item.length,
                        );
                      } else if (state is SearchEmptyState) {
                        return Container();
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
