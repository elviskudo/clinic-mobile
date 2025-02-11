import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FBF2),
      body: Center(
        child: Container(
            width: 185,
            height: 185,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/logoclinicai.png")),
            )),
      ),
    );
  }
}
