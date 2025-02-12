import 'dart:async';

import 'package:andri_driweather/model/current_weather.dart';
import 'package:andri_driweather/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherState()) {
    on<SetWeatherData>(onSetWeatherData);
    on<UpdateWeatherData>(onUpdateWeatherData);
    on<FetchWeather>(onFetchWeather);
    on<EmitWeather>(onEmitWeather);
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permission denied forever');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return position;
  }

  FutureOr<void> onSetWeatherData(
      SetWeatherData event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? latLngString = prefs.getString('latLng');
      if (latLngString != null) {
        List<String> latLngParts = latLngString.split(',');
        double latitude = double.parse(latLngParts[0]);
        double longitude = double.parse(latLngParts[1]);

        List<Placemark>? placemarks = await GeocodingPlatform.instance
            ?.placemarkFromCoordinates(latitude, longitude);
        if (placemarks != null && placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          emit(state.copyWith(cityName: place.locality!));
          add(FetchWeather(latitude.toString(), longitude.toString()));
        } else {
          emit(
              state.copyWith(errorMessage: 'City Not Found', isLoading: false));
        }
      } else {
        try {
          Position? position = await getCurrentLocation();
          if (position != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String latLngString = '${position.latitude},${position.longitude}';
            await prefs.setString('latLng', latLngString);
            List<Placemark>? placemarks = await GeocodingPlatform.instance
                ?.placemarkFromCoordinates(
                    position.latitude, position.longitude);
            if (placemarks != null && placemarks.isNotEmpty) {
              Placemark place = placemarks.first;
              emit(state.copyWith(cityName: place.locality!));
              add(FetchWeather(
                  position.latitude.toString(), position.longitude.toString()));
            } else {
              emit(state.copyWith(
                  errorMessage: 'City Not Found', isLoading: false));
            }
          }
        } catch (e) {
          emit(
              state.copyWith(errorMessage: 'City Not Found', isLoading: false));
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> onUpdateWeatherData(
      UpdateWeatherData event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? latLngString = prefs.getString('latLng');
      if (latLngString != null) {
        List<String> latLngParts = latLngString.split(',');
        double latitude = double.parse(latLngParts[0]);
        double longitude = double.parse(latLngParts[1]);

        List<Placemark>? placemarks = await GeocodingPlatform.instance
            ?.placemarkFromCoordinates(latitude, longitude);
        if (placemarks != null && placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          emit(state.copyWith(cityName: place.locality!));
          add(FetchWeather(latitude.toString(), longitude.toString()));
        } else {
          emit(
              state.copyWith(errorMessage: 'City Not Found', isLoading: false));
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  FutureOr<void> onFetchWeather(
      FetchWeather event, Emitter<WeatherState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      WeatherServices()
          .fetchForecastNow(event.latitude, event.longitude)
          .then((value) {
        if (value != null) {
          CurrentWeather weatherData = value as CurrentWeather;
          add(EmitWeather(weatherData));
        } else {
          emit(state.copyWith(
              errorMessage: 'Failed to Fetch', isLoading: false));
        }
      });
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void onEmitWeather(EmitWeather event, Emitter<WeatherState> emit) {
    emit(state.copyWith(
        weather: event.weather, isLoading: false, errorMessage: ''));
  }
}
