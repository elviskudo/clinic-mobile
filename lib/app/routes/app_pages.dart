import 'package:get/get.dart';

import '../modules/(admin)/admin_panel/bindings/admin_panel_binding.dart';
import '../modules/(admin)/admin_panel/views/admin_panel_view.dart';
import '../modules/(admin)/clinic/bindings/clinic_binding.dart';
import '../modules/(admin)/clinic/views/clinic_view.dart';
import '../modules/(admin)/list_user/bindings/list_user_binding.dart';
import '../modules/(admin)/list_user/views/list_user_view.dart';
import '../modules/(admin)/poly/bindings/poly_binding.dart';
import '../modules/(admin)/poly/views/poly_view.dart';
import '../modules/(home)/account_settings/bindings/account_settings_binding.dart';
import '../modules/(home)/account_settings/views/account_settings_view.dart';
import '../modules/(home)/home/bindings/home_binding.dart';
import '../modules/(home)/home/views/home_view.dart';
import '../modules/(home)/login/bindings/login_binding.dart';
import '../modules/(home)/login/views/login_view.dart';
import '../modules/(home)/onboarding_page/bindings/onboarding_page_binding.dart';
import '../modules/(home)/onboarding_page/views/onboarding_page_view.dart';
import '../modules/(home)/personal_data/bindings/personal_data_binding.dart';
import '../modules/(home)/personal_data/views/personal_data_view.dart';
import '../modules/(home)/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/(home)/splash_screen/views/splash_screen_view.dart';
import '../modules/(home)/verification/bindings/verification_binding.dart';
import '../modules/(home)/verification/views/verification_view.dart';
import '../modules/(home)/verificationSuccess/bindings/verification_success_binding.dart';
import '../modules/(home)/verificationSuccess/views/verification_success_view.dart';
import '../modules/(admin)/doctor/bindings/doctor_binding.dart';
import '../modules/(admin)/doctor/views/doctor_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
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
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_PAGE,
      page: () => const OnboardingPageView(),
      binding: OnboardingPageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.PERSONAL_DATA,
      page: () => const PersonalDataView(),
      binding: PersonalDataBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_SETTINGS,
      page: () => const AccountSettingsView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PANEL,
      page: () => const AdminPanelView(),
      binding: AdminPanelBinding(),
    ),
    GetPage(
      name: _Paths.CLINIC,
      page: () => const ClinicView(),
      binding: ClinicBinding(),
    ),
    GetPage(
      name: _Paths.LIST_USER,
      page: () => ListUserView(),
      binding: ListUserBinding(),
    ),
    GetPage(
      name: _Paths.POLY,
      page: () => const PolyView(),
      binding: PolyBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR,
      page: () => const DoctorView(),
      binding: DoctorBinding(),
    ),
  ];
}
