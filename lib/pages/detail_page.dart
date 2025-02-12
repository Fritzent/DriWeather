import 'package:andri_driweather/bloc/detail_weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../resources/style_config.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String date;

  String formatDateNow() {
    DateTime now = DateTime.now();
    return DateFormat("MMM, d").format(now);
  }

  String getWeatherCondition(int code) {
    switch (code) {
      case 0:
        return "Unknow";
      case 1000:
        return "Clear";
      case 1100:
        return "Mostly Clear";
      case 1101:
        return "Partly Cloudy";
      case 1102:
        return "Mostly Cloudy";
      case 1001:
        return "Cloudy";
      case 2000:
        return "Fog";
      case 2100:
        return "Light Fog";
      case 4000:
        return "Drizzle";
      case 4001:
        return "Rain";
      case 4200:
        return "Light Rain";
      case 4201:
        return "Heavy Rain";
      case 5000:
        return "Snow";
      case 5001:
        return "Flurries";
      case 5100:
        return "Light Snow";
      case 5101:
        return "Heavy Snow";
      case 6000:
        return "Freezing Drizzle";
      case 6001:
        return "Freezing Rain";
      case 6200:
        return "Light Freezing Rain";
      case 6201:
        return "Heavy Freezing Rain";
      case 7000:
        return "Ice Pellets";
      case 7101:
        return "Heavy Ice Pellets";
      case 7102:
        return "Light Ice Pellets";
      case 8000:
        return "Thunderstorm";
      default:
        return "Unknown";
    }
  }

  String getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return "assets/icons/ic_weather_sunny.svg";
      case 1000:
        return "assets/icons/ic_weather_sunny.svg";
      case 1100:
        return "assets/icons/ic_weather_cloudy.svg";
      case 1101:
        return "assets/icons/ic_weather_cloud_one.svg";
      case 1102:
        return "assets/icons/ic_weather_cloud_with_monn.svg";
      case 1001:
        return "assets/icons/ic_weather_cloudy.svg";
      case 2000:
      case 2100:
        return "assets/icons/ic_weather_cloudy.svg";
      case 4000:
      case 4001:
        return "assets/icons/ic_weather_rainy.svg";
      case 4200:
      case 4201:
        return "assets/icons/ic_weather_rain_with_lightning.svg";

      case 5000:
      case 5001:
      case 5100:
      case 5101:
        return "assets/icons/ic_weather_cloudy.svg";

      case 6000:
      case 6001:
        return "assets/icons/ic_weather_rainy.svg";
      case 6200:
      case 6201:
        return "assets/icons/ic_weather_rain_with_lightning.svg";

      case 7000:
      case 7101:
      case 7102:
        return "assets/icons/ic_weather_rainy.svg";

      case 8000:
        return "assets/icons/ic_weather_rain_with_lightning.svg";
      default:
        return "assets/icons/ic_weather_sunny.svg";
    }
  }

  @override
  void initState() {
    date = formatDateNow();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailWeatherBloc()..add(StartFetchData()),
      child: BlocBuilder<DetailWeatherBloc, DetailWeatherState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Scaffold(
              backgroundColor: ColorList.whiteColor,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorList.homeBackgroundPrimary,
                        ColorList.homeBackgroundSecondary
                      ],
                      tileMode: TileMode.mirror,
                    )),
                    padding: EdgeInsets.only(
                        left: FontList.font30,
                        right: FontList.font30,
                        top: FontList.font36 +
                            MediaQuery.of(context).padding.top,
                        bottom: FontList.font36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset('assets/icons/ic_back.svg')),
                            Gap(FontList.font16),
                            Text("Back",
                                style: GoogleFonts.overpass(
                                    fontSize: FontList.font24,
                                    fontWeight: FontWeight.w600,
                                    color: ColorList.whiteColor)),
                          ],
                        ),
                        const SizedBox(height: 51),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text("Today",
                                  style: GoogleFonts.overpass(
                                      fontSize: FontList.font24,
                                      fontWeight: FontWeight.w900,
                                      color: ColorList.whiteColor)),
                            ),
                            Text(date,
                                style: GoogleFonts.overpass(
                                    fontSize: FontList.font18,
                                    fontWeight: FontWeight.w400,
                                    color: ColorList.whiteColor)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: false,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                final weather = state.todayWeather?.data
                                    ?.timelines?[0].intervals?[index];
                                DateTime? utcDateTime =
                                    weather?.startTime?.toUtc();
                                DateTime? utc7DateTime =
                                    utcDateTime?.add(Duration(hours: 7));
                                String formattedTime =
                                    '${utc7DateTime?.hour.toString().padLeft(2, '0')}:00';
                            
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _hourlyWeather(
                                        weather?.values?.temperature
                                                ?.toString() ??
                                            '',
                                        getWeatherIcon(
                                            weather?.values?.weatherCode ?? 0),
                                        formattedTime,
                                        isSelected: utc7DateTime?.hour ==
                                            DateTime.now().hour)
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Text("Next Forecast",
                            style: GoogleFonts.overpass(
                                fontSize: FontList.font24,
                                fontWeight: FontWeight.w900,
                                color: ColorList.whiteColor)),
                        Expanded(
                          flex: 2,
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 6,
                            radius: const Radius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.only(right: FontList.font40),
                              child: ListView.builder(
                                padding: EdgeInsets.all(8.0),
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  final weather = state.nextWeather?.data
                                      ?.timelines?[0].intervals?[index];
                                  String? formattedTime =
                                      weather?.startTime != null
                                          ? DateFormat("MMM, d")
                                              .format(weather!.startTime!)
                                          : null;
                              
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        children: [
                                          _nextForecast(
                                              formattedTime ?? '',
                                              getWeatherIcon(
                                                  weather?.values?.weatherCode ?? 0),
                                              weather?.values?.temperature
                                                      ?.toString() ??
                                                  '')
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Gap(59),
                        Center(
                            child: Row(
                          spacing: 15,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/sun.svg',
                              colorFilter: ColorFilter.mode(
                                  ColorList.whiteColor, BlendMode.srcIn),
                            ),
                            Text("DRI Weather",
                                style: GoogleFonts.overpass(
                                    fontSize: FontList.font18,
                                    fontWeight: FontWeight.w400,
                                    color: ColorList.whiteColor)),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _hourlyWeather(String temp, String icon, String time,
      {bool isSelected = false}) {
    return Container(
      padding: isSelected ? EdgeInsets.all(13) : EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: ColorList.grayColor100) : null,
      ),
      child: Column(
        children: [
          Text('$temp°C',
              style: GoogleFonts.overpass(
                  fontSize: FontList.font18,
                  fontWeight: FontWeight.w400,
                  color: ColorList.whiteColor)),
          const SizedBox(height: 23),
          SvgPicture.asset(
            height: 32,
            width: 32,
            icon,
          ),
          const SizedBox(height: 6),
          Text(time,
              style: GoogleFonts.overpass(
                  fontSize: FontList.font18,
                  fontWeight: FontWeight.w400,
                  color: ColorList.whiteColor)),
        ],
      ),
    );
  }

  Widget _nextForecast(String date, String icon, String temp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 48,
        children: [
          Text(date,
              style: GoogleFonts.overpass(
                  fontSize: FontList.font18,
                  fontWeight: FontWeight.w700,
                  color: ColorList.whiteColor)),
          SvgPicture.asset(
            icon,
          ),
          Text('$temp°',
              style: GoogleFonts.overpass(
                  fontSize: FontList.font18,
                  fontWeight: FontWeight.w400,
                  color: ColorList.whiteColor)),
        ],
      ),
    );
  }
}
