import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/splash_screens.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 180),
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundcolour,
          canvasColor: AppColors.backgroundcolour,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.backgroundcolour,
            surfaceTintColor: AppColors.backgroundcolour,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
