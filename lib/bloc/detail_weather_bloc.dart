import 'dart:async';

import 'package:andri_driweather/model/current_weather.dart';
import 'package:andri_driweather/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'detail_weather_event.dart';
part 'detail_weather_state.dart';

class DetailWeatherBloc extends Bloc<DetailWeatherEvent, DetailWeatherState> {
  DetailWeatherBloc() : super(DetailWeatherState()) {
    on<EmitWeather>(onEmitWeather);
    on<StartFetchData>(onStartFetchData);
    on<FetchTodayForecast>(onFetchTodayForecast);
    on<FetchNextForecast>(onFetchNextForecast);
  }

  FutureOr<void>onStartFetchData(StartFetchData event, Emitter<DetailWeatherState> emit) {
    add(FetchTodayForecast());
    add(FetchNextForecast());
  }

  FutureOr<void> onFetchNextForecast(
      FetchNextForecast event, Emitter<DetailWeatherState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? latLngString = prefs.getString('latLng');
      if (latLngString != null) {
        List<String> latLngParts = latLngString.split(',');
        double latitude = double.parse(latLngParts[0]);
        double longitude = double.parse(latLngParts[1]);

        WeatherServices()
            .fetchNextForecast(latitude.toString(), longitude.toString())
            .then((value) {
          if (value != null) {
            CurrentWeather weatherData = value as CurrentWeather;
            add(EmitWeather(nextWeather: weatherData, isTodayWeather: false));
          }
          else {
            emit(state.copyWith(errorMessage: 'Failed to Fetch', isLoading: false));
          }
        });
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  FutureOr<void> onFetchTodayForecast(
      FetchTodayForecast event, Emitter<DetailWeatherState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? latLngString = prefs.getString('latLng');
      if (latLngString != null) {
        List<String> latLngParts = latLngString.split(',');
        double latitude = double.parse(latLngParts[0]);
        double longitude = double.parse(latLngParts[1]);

        WeatherServices()
            .fetchTodayForecast(latitude.toString(), longitude.toString())
            .then((value) {
          if (value != null) {
            CurrentWeather weatherData = value as CurrentWeather;
            add(EmitWeather(todayWeather: weatherData, isTodayWeather: true));
          }
          else {
            emit(state.copyWith(errorMessage: 'Failed to Fetch', isLoading: false));
          }
        });
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void onEmitWeather(EmitWeather event, Emitter<DetailWeatherState> emit) {
    if (event.isTodayWeather) {
      emit(state.copyWith(
        todayWeather: event.todayWeather,
        isLoading: false,
        errorMessage: '',
      ));
    } else {
      emit(state.copyWith(
        nextWeather: event.nextWeather,
        isLoading: false,
        errorMessage: '',
      ));
    }
  }
}
