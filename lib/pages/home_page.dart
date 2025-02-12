import 'package:andri_driweather/bloc/weather_bloc.dart';
import 'package:andri_driweather/resources/notification_dummy.dart';
import 'package:andri_driweather/widgets/button_primary.dart';
import 'package:andri_driweather/widgets/modal_bottom_sheet_notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../resources/style_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String date;
  String formatDateNow() {
    DateTime now = DateTime.now();
    return DateFormat("d MMMM").format(now);
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
      create: (context) => WeatherBloc()..add(SetWeatherData()),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Scaffold(
              backgroundColor: ColorList.whiteColor,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          var bloc = context.read<WeatherBloc>();
          return Scaffold(
            body: Center(
                child: Container(
              width: double.infinity,
              height: double.infinity,
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
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: -120,
                      child: SvgPicture.asset(
                        height: FontList.font378,
                        width: FontList.font604,
                        'assets/icons/line_background_one.svg',
                      )),
                  Positioned(
                      top: 120,
                      left: 0,
                      child: SvgPicture.asset(
                        height: FontList.font378,
                        width: FontList.font604,
                        'assets/icons/line_background_two.svg',
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        left: FontList.font30,
                        right: FontList.font30,
                        top: FontList.font36 +
                            MediaQuery.of(context).padding.top,
                        bottom: FontList.font36),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: FontList.font20,
                                children: [
                                  SvgPicture.asset(
                                    height: FontList.font24,
                                    width: FontList.font24,
                                    'assets/icons/map.svg',
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      state.cityName.isNotEmpty
                                          ? state.cityName
                                          : '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.overpass(
                                        color: ColorList.whiteColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: FontList.font24,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        var result = await Navigator.pushNamed(
                                            context, '/search_page');
                                        if (result != null) {
                                          //LatLng location = result as LatLng;
                                          bloc.add(UpdateWeatherData());
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            height: FontList.font24,
                                            width: FontList.font24,
                                            'assets/icons/opt.svg',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  showBottomSheetNotif(
                                      context: context,
                                      isDismissible: true,
                                      enableDrag: true,
                                      notificationItem: notificationsDummyData);
                                },
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      height: FontList.font24,
                                      width: FontList.font24,
                                      'assets/icons/notif.svg',
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                            color: ColorList.redColor,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                width: 2,
                                                color:
                                                    ColorList.lightBlueColor)),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    height: FontList.font85,
                                    width: FontList.font135,
                                    getWeatherIcon(state
                                            .weather
                                            ?.data
                                            ?.timelines?[0]
                                            .intervals?[0]
                                            .values
                                            ?.weatherCode ??
                                        0),
                                  ),
                                ),
                                Gap(34),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: FontList.font16,
                                      vertical: FontList.font16),
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(colors: [
                                      ColorList.whiteColor,
                                      ColorList.whiteColor200
                                    ], radius: 70),
                                    color: ColorList.whiteColor
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: ColorList.whiteColor
                                          .withValues(alpha: 0.3),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Today, $date',
                                        style: GoogleFonts.overpass(
                                            fontSize: FontList.font18,
                                            fontWeight: FontWeight.w400,
                                            color: ColorList.whiteColor),
                                      ),
                                      Text(
                                        '${state
                                                .weather
                                                ?.data
                                                ?.timelines?[0]
                                                .intervals?[0]
                                                .values
                                                ?.temperature
                                                !}°',
                                        style: GoogleFonts.overpass(
                                            fontSize: FontList.font100,
                                            fontWeight: FontWeight.w400,
                                            color: ColorList.whiteColor),
                                      ),
                                      Text(
                                        getWeatherCondition(state
                                                .weather
                                                ?.data
                                                ?.timelines?[0]
                                                .intervals?[0]
                                                .values
                                                ?.weatherCode ??
                                            0),
                                        style: GoogleFonts.overpass(
                                            fontSize: FontList.font24,
                                            fontWeight: FontWeight.w700,
                                            color: ColorList.whiteColor),
                                      ),
                                      Gap(FontList.font24),
                                      IntrinsicWidth(
                                        stepWidth: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          spacing: FontList.font20,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  height: FontList.font24,
                                                  width: FontList.font24,
                                                  'assets/icons/windy.svg',
                                                ),
                                                Gap(FontList.font20),
                                                Text(
                                                  'Wind',
                                                  style: GoogleFonts.overpass(
                                                      fontSize: FontList.font18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          ColorList.whiteColor),
                                                ),
                                                Gap(FontList.font20),
                                                Text(
                                                  '|',
                                                  style: GoogleFonts.overpass(
                                                      fontSize: FontList.font18,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color:
                                                          ColorList.whiteColor),
                                                ),
                                                Gap(FontList.font20),
                                                Text(
                                                  '${state.weather?.data?.timelines?[0].intervals?[0].values?.windSpeed}km/h',
                                                  style: GoogleFonts.overpass(
                                                      fontSize: FontList.font18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          ColorList.whiteColor),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  height: FontList.font24,
                                                  width: FontList.font24,
                                                  'assets/icons/hum.svg',
                                                ),
                                                Gap(FontList.font20),
                                                Text(
                                                  'Hum ',
                                                  style: GoogleFonts.overpass(
                                                      fontSize: FontList.font18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          ColorList.whiteColor),
                                                ),
                                                Gap(FontList.font20),
                                                Text(
                                                  '|',
                                                  style: GoogleFonts.overpass(
                                                      fontSize: FontList.font18,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color:
                                                          ColorList.whiteColor),
                                                ),
                                                Gap(FontList.font20),
                                                Text(
                                                  '${state.weather?.data?.timelines?[0].intervals?[0].values?.humidity}%',
                                                  style: GoogleFonts.overpass(
                                                      fontSize: FontList.font18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          ColorList.whiteColor),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Gap(FontList.font16),
                        ButtonPrimary(
                            onTap: () {
                              Navigator.pushNamed(context, '/detail_page');
                            },
                            buttonText: 'Weather Details',
                            includeIcon: true),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}
