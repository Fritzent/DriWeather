import 'dart:io';

import 'package:andri_driweather/repository/notification_service.dart';
import 'package:andri_driweather/resources/style_config.dart';
import 'package:andri_driweather/widgets/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  const OnboardPage({super.key, required this.notificationsPlugin});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  late NotificationService notificationService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notificationService = RepositoryProvider.of<NotificationService>(context);
  }

  Future<void> requestNotificationPermission(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    if (Platform.isIOS) {
      final iosImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final bool? result = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        print('iOS notification permission granted: $result');
      }
    } else if (Platform.isAndroid) {
      try {
        final status = await Permission.notification.request();
        if (status.isGranted) {
          print('Android notification permission granted');
        } else {
          print('Android notification permission denied');
        }
      } catch (e) {}
    }
  }

  @override
  void initState() {
    requestNotificationPermission(widget.notificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorList.onBoardBackgroundPrimary,
              ColorList.onBoardBackgroundSecondary
            ],
            tileMode: TileMode.mirror,
          )),
          child: Stack(
            children: [
              Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        bottom: 100,
                        left: -10,
                        child: Container(
                            width: 789,
                            height: 789,
                            decoration: ShapeDecoration(
                                color: Colors.transparent,
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: ColorList.whiteColor)))),
                      ),
                      Positioned(
                        bottom: 200,
                        left: 70,
                        child: Container(
                            width: 587,
                            height: 587,
                            decoration: ShapeDecoration(
                                color: Colors.transparent,
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: ColorList.whiteColor)))),
                      ),
                      Positioned(
                        bottom: 300,
                        left: 150,
                        child: Container(
                            width: 386,
                            height: 386,
                            decoration: ShapeDecoration(
                                color: Colors.transparent,
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: ColorList.whiteColor)))),
                      ),
                      Positioned(
                        bottom: 400,
                        right: -20,
                        child: Container(
                            width: 170,
                            height: 170,
                            decoration: ShapeDecoration(
                                color: Colors.transparent,
                                shape: CircleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: ColorList.whiteColor)))),
                      )
                    ],
                  ),
                  Positioned(
                      top: FontList.font69,
                      left: -FontList.font90,
                      child: SvgPicture.asset(
                        height: FontList.font187,
                        width: FontList.font176,
                        'assets/icons/sun_background.svg',
                      )),
                  Positioned(
                      bottom: 105,
                      left: 60,
                      child: SvgPicture.asset(
                        height: FontList.font378,
                        width: FontList.font604,
                        'assets/icons/cloud_background.svg',
                      )),
                ],
              ),
              Positioned(
                bottom: FontList.font60,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(horizontal: 54),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Never get caught in the rain again',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: GoogleFonts.overpass(
                            fontWeight: FontWeight.w700,
                            fontSize: FontList.font40,
                            color: ColorList.blackColor),
                      ),
                      Gap(8),
                      Text(
                        'Stay ahead of the weather with our accurate forecasts',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: GoogleFonts.overpass(
                            fontWeight: FontWeight.w400,
                            fontSize: FontList.font16,
                            color: ColorList.blackColor),
                      ),
                      Gap(23),
                      ButtonPrimary(
                        onTap: () async {
                          await notificationService.showWelcomeNotification(
                              'Hi, Sobat DriWeather',
                              'Mari check cuaca di daerah kamu hari ini bersama kami');

                          final FlutterSecureStorage secureStorage =
                              FlutterSecureStorage();
                          await secureStorage.write(
                              key: 'isBoardingDone', value: 'Done');

                          Navigator.popAndPushNamed(context, '/home');
                        },
                        buttonText: 'Get Started',
                        includeIcon: false,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
