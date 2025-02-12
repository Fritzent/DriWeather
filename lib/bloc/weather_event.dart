part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

class SetWeatherData extends WeatherEvent{
}

class UpdateWeatherData extends WeatherEvent {
}

class FetchWeather extends WeatherEvent {
  final String latitude;
  final String longitude;
  FetchWeather(this.latitude, this.longitude);
}

class EmitWeather extends WeatherEvent {
  final CurrentWeather weather;
  EmitWeather(this.weather);
}
