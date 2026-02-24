import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tang_soo_karate/authentication/sign_in_screen.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(seconds: 3), () {
  //     if (!mounted) return;
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const SignInScreen()),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/splashscreen.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 0,
          left: 0,
          child: AppButton(
            onPress: () {
              Get.to(SignInScreen());
            },
            text: "Get Started",
            backgroundColor: Color(0xff38B26E),
            horizontalMargin: 30,
          ),
        ),
      ],
    );
  }
}
