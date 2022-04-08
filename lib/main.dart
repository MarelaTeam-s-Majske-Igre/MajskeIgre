import 'package:app/screens/about_app/about_app_screen.dart';
import 'package:app/screens/cubit_screens/error_screen.dart';
import 'package:app/screens/cubit_screens/loading_screen.dart';
import 'package:app/screens/event/culture/culture_event_screen.dart';
import 'package:app/screens/event/concert_event/fun_event_screen.dart';
import 'package:app/screens/event/sport_event/sport_event_screen.dart';
import 'package:app/screens/events_list/event_list_screen.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/search/search_screen.dart';
import 'package:app/services/firebase/fcm.dart';
import 'package:app/services/global/global_context.dart';
import 'package:app/style/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  notificationSetup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('sl');
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey, // set property
      debugShowCheckedModeBanner: false,
      title: 'Majske igre',
      theme: ThemeData(
        primarySwatch: ThemeColors.primaryBlue,
      ),
      routes: {
        '/event/sport': (context) => SportEventDetailScreen(),
        '/event/fun': (context) => FunEventDetailScreen(),
        '/event/culture': (context) => CultureEventDetailScreen(),
        '/events': (context) => EventListScreen(),
        '/about': (context) => AboutAppScreen(),
        '/search': (context) => SearchScreen(),
      },
      home: HomeScreen(),
    );
  }
}
