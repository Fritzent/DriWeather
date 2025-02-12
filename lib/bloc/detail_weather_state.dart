part of 'detail_weather_bloc.dart';

class DetailWeatherState {
  final bool isLoading;
  final CurrentWeather? todayWeather;
  final CurrentWeather? nextWeather;
  final String? errorMessage;

  DetailWeatherState({
    this.isLoading = false,
    this.todayWeather,
    this.nextWeather,
    this.errorMessage = '',
  });

  DetailWeatherState copyWith ({
    bool? isLoading,
    CurrentWeather? todayWeather,
    CurrentWeather? nextWeather,
    String? errorMessage,
  }) {
    return DetailWeatherState(
      isLoading: isLoading ?? this.isLoading,
      todayWeather: todayWeather ?? this.todayWeather,
      nextWeather: nextWeather ?? this.nextWeather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
