import 'package:andri_driweather/bloc/session_bloc.dart';
import 'package:andri_driweather/pages/detail_page.dart';
import 'package:andri_driweather/pages/onboard_page.dart';
import 'package:andri_driweather/pages/search_page.dart';
import 'package:andri_driweather/repository/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/home_page.dart';
import 'resources/style_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidInitializationSettings initializationSettingsAndroid;
  late DarwinInitializationSettings iosSettings;

  initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  iosSettings = DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iosSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    runApp(RepositoryProvider(
        create: (context) => NotificationService(
            flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin),
        child: MyApp(
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        )));
  });
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  const MyApp({super.key, required this.flutterLocalNotificationsPlugin});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionBloc()..add(CheckSession()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: ColorList.whiteColor,
          textTheme: GoogleFonts.overpassMonoTextTheme(),
          scrollbarTheme: ScrollbarThemeData(
            thumbColor:
                WidgetStatePropertyAll(Colors.white),
            trackColor: WidgetStatePropertyAll(
                ColorList.whiteColor),
            thickness: WidgetStatePropertyAll(6),
            radius: const Radius.circular(10),
          ),
        ),
        home: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.status == SessionStatus.found && !state.isLoading) {
              return HomePage();
            }
            return OnboardPage(
                notificationsPlugin: flutterLocalNotificationsPlugin);
          },
        ),
        routes: {
          '/home': (context) => HomePage(),
          '/onboard': (context) => OnboardPage(
                notificationsPlugin: flutterLocalNotificationsPlugin,
              ),
          '/detail_page': (context) => DetailPage(),
          '/search_page': (context) => SearchLocationPage(),
        },
      ),
    );
  }
}
