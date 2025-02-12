// To parse this JSON data, do
//
//     final currentWeather = currentWeatherFromJson(jsonString);

import 'dart:convert';

CurrentWeather currentWeatherFromJson(String str) => CurrentWeather.fromJson(json.decode(str));

String currentWeatherToJson(CurrentWeather data) => json.encode(data.toJson());

class CurrentWeather {
    final Data? data;

    CurrentWeather({
        this.data,
    });

    CurrentWeather copyWith({
        Data? data,
    }) => 
        CurrentWeather(
            data: data ?? this.data,
        );

    factory CurrentWeather.fromJson(Map<String, dynamic> json) => CurrentWeather(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };
}

class Data {
    final List<Timeline>? timelines;

    Data({
        this.timelines,
    });

    Data copyWith({
        List<Timeline>? timelines,
    }) => 
        Data(
            timelines: timelines ?? this.timelines,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        timelines: json["timelines"] == null ? [] : List<Timeline>.from(json["timelines"]!.map((x) => Timeline.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "timelines": timelines == null ? [] : List<dynamic>.from(timelines!.map((x) => x.toJson())),
    };
}

class Timeline {
    final String? timestep;
    final DateTime? endTime;
    final DateTime? startTime;
    final List<Interval>? intervals;

    Timeline({
        this.timestep,
        this.endTime,
        this.startTime,
        this.intervals,
    });

    Timeline copyWith({
        String? timestep,
        DateTime? endTime,
        DateTime? startTime,
        List<Interval>? intervals,
    }) => 
        Timeline(
            timestep: timestep ?? this.timestep,
            endTime: endTime ?? this.endTime,
            startTime: startTime ?? this.startTime,
            intervals: intervals ?? this.intervals,
        );

    factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        timestep: json["timestep"],
        endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
        startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
        intervals: json["intervals"] == null ? [] : List<Interval>.from(json["intervals"]!.map((x) => Interval.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "timestep": timestep,
        "endTime": endTime?.toIso8601String(),
        "startTime": startTime?.toIso8601String(),
        "intervals": intervals == null ? [] : List<dynamic>.from(intervals!.map((x) => x.toJson())),
    };
}

class Interval {
    final DateTime? startTime;
    final Values? values;

    Interval({
        this.startTime,
        this.values,
    });

    Interval copyWith({
        DateTime? startTime,
        Values? values,
    }) => 
        Interval(
            startTime: startTime ?? this.startTime,
            values: values ?? this.values,
        );

    factory Interval.fromJson(Map<String, dynamic> json) => Interval(
        startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "startTime": startTime?.toIso8601String(),
        "values": values?.toJson(),
    };
}

class Values {
    final double? dewPoint;
    final int? humidity;
    final double? temperature;
    final double? temperatureApparent;
    final int? weatherCode;
    final double? windSpeed;

    Values({
        this.dewPoint,
        this.humidity,
        this.temperature,
        this.temperatureApparent,
        this.weatherCode,
        this.windSpeed,
    });

    Values copyWith({
        double? dewPoint,
        int? humidity,
        double? temperature,
        double? temperatureApparent,
        int? weatherCode,
        double? windSpeed,
    }) => 
        Values(
            dewPoint: dewPoint ?? this.dewPoint,
            humidity: humidity ?? this.humidity,
            temperature: temperature ?? this.temperature,
            temperatureApparent: temperatureApparent ?? this.temperatureApparent,
            weatherCode: weatherCode ?? this.weatherCode,
            windSpeed: windSpeed ?? this.windSpeed,
        );

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        dewPoint: json["dewPoint"]?.toDouble(),
        humidity: json["humidity"],
        temperature: json["temperature"]?.toDouble(),
        temperatureApparent: json["temperatureApparent"]?.toDouble(),
        weatherCode: json["weatherCode"],
        windSpeed: json["windSpeed"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "dewPoint": dewPoint,
        "humidity": humidity,
        "temperature": temperature,
        "temperatureApparent": temperatureApparent,
        "weatherCode": weatherCode,
        "windSpeed": windSpeed,
    };
}
