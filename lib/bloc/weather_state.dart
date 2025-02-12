part of 'weather_bloc.dart';

class WeatherState {
  final bool isLoading;
  final String cityName;
  final LatLng? location;
  final String? errorMessage;
  final CurrentWeather? weather;

  WeatherState(
      {this.isLoading = false,
      this.cityName = '',
      this.location,
      this.errorMessage,
      this.weather});

  WeatherState copyWith({
    bool? isLoading,
    String? cityName,
    LatLng? location,
    String? errorMessage,
    CurrentWeather? weather,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      cityName: cityName ?? this.cityName,
      location: location ?? this.location,
      errorMessage: errorMessage ?? this.errorMessage,
      weather: weather ?? this.weather,
    );
  }
}
