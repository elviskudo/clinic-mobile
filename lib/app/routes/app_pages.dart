import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/verification/bindings/verification_binding.dart';
import '../modules/verification/views/verification_view.dart';
import '../modules/verificationSuccess/bindings/verification_success_binding.dart';
import '../modules/verificationSuccess/views/verification_success_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.VERIVICATION,
      page: () => const VerificationView(),
      binding: VerivicationBinding(),
    ),
    GetPage(
      name: _Paths.VERIVICATION_SUCCESS,
      page: () => const VerificationSuccessView(),
      binding: VerivicationSuccessBinding(),
    ),
  ];
}
