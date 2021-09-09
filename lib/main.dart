import 'package:doit/pages/add-task/index.dart';
import 'package:doit/pages/get-started/index.dart';
import 'package:doit/pages/home/index.dart';
import 'package:doit/services/notification/notification-service.dart';
import 'package:doit/theme/app-theme.dart';
import 'package:doit/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'pages/splash/index.dart';
import 'services/db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DoItDatabase().openDoItDatabase();

  tz.initializeTimeZones();

  runApp(DoItApp());
}

class DoItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NotificationService())],
      child: MaterialApp(
        title: 'DoIt',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: AppConstants.Splash,
        routes: {
          AppConstants.Splash: (context) => const SplashPage(),
          AppConstants.Index: (context) => const GetStarted(),
          AppConstants.Home: (context) => const HomePage(),
          AppConstants.AddTask: (context) => const AddTask(),
        },
      ),
    );
  }
}
