import 'dart:convert';
import 'package:andri_driweather/model/current_weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  fetchForecastNow(String lat, String long) async {
    final Uri url = Uri.parse(
        "$baseUrl?location=$lat,$long&fields=windSpeed&units=metric&fields=humidity&fields=temperature&fields=weatherCode&fields=dewPoint&fields=temperatureApparent&timesteps=current&apikey=$apiKey");

    try {
      final response = await http.get(
        url,
        headers: {
          "accept": "application/json",
          "accept-encoding": "deflate, gzip, br",
        },
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        CurrentWeather value = CurrentWeather.fromJson(json);
        return value;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  fetchTodayForecast(String lat, String long) async {
    // Get the current UTC time
    DateTime now = DateTime.now().toUtc();

    // Calculate start and end times (ISO format)
    String startTime = now.subtract(Duration(hours: 2)).toIso8601String();
    String endTime = now.add(Duration(hours: 2)).toIso8601String();

    final Uri url = Uri.parse(
        "$baseUrl?location=$lat,$long&fields=windSpeed&units=metric&fields=humidity&fields=temperature&fields=weatherCode&fields=dewPoint&fields=temperatureApparent&timesteps=1h&startTime=${startTime}&endTime=${endTime}&apikey=$apiKey");

    try {
      final response = await http.get(
        url,
        headers: {
          "accept": "application/json",
          "accept-encoding": "deflate, gzip, br",
        },
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        CurrentWeather value = CurrentWeather.fromJson(json);
        return value;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  fetchNextForecast(String lat, String long) async {
    final Uri url = Uri.parse(
        "$baseUrl?location=$lat,$long&fields=windSpeed&units=metric&fields=humidity&fields=temperature&fields=weatherCode&fields=dewPoint&fields=temperatureApparent&timesteps=1d&apikey=$apiKey");

    try {
      final response = await http.get(
        url,
        headers: {
          "accept": "application/json",
          "accept-encoding": "deflate, gzip, br",
        },
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        CurrentWeather value = CurrentWeather.fromJson(json);
        return value;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
