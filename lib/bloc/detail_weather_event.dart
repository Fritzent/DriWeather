part of 'detail_weather_bloc.dart';

@immutable
sealed class DetailWeatherEvent {}

class StartFetchData extends DetailWeatherEvent{
  
}

class FetchTodayForecast extends DetailWeatherEvent {
}

class FetchNextForecast extends DetailWeatherEvent {

}

class EmitWeather extends DetailWeatherEvent{
  final CurrentWeather? todayWeather;
  final CurrentWeather? nextWeather;
  final bool isTodayWeather;
  EmitWeather({this.todayWeather, this.nextWeather, this.isTodayWeather = true});
}
