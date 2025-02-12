import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final SplashScreenController controller = Get.put(SplashScreenController());
=======
    Get.put(SplashScreenController());
>>>>>>> aa00429ed23ace176bbd3cf953cacb70234823fd
    return Scaffold(
      backgroundColor: Color(0xffF7FBF2),
      body: Center(
        child: Container(
            width: 185,
            height: 185,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("assets/images/logo.png")),
            )),
      ),
    );
  }
}
