import 'package:clinic_ai/app/modules/(admin)/admin_panel/bindings/admin_panel_binding.dart';
import 'package:clinic_ai/app/modules/(admin)/admin_panel/views/admin_panel_view.dart';
import 'package:clinic_ai/app/modules/(home)/account_settings/bindings/account_settings_binding.dart';
import 'package:clinic_ai/app/modules/(home)/account_settings/views/account_settings_view.dart';
import 'package:clinic_ai/app/modules/(home)/home/bindings/home_binding.dart';
import 'package:clinic_ai/app/modules/(home)/home/views/home_view.dart';
import 'package:clinic_ai/app/modules/(home)/login/bindings/login_binding.dart';
import 'package:clinic_ai/app/modules/(home)/login/views/login_view.dart';
import 'package:clinic_ai/app/modules/(home)/onboarding_page/bindings/onboarding_page_binding.dart';
import 'package:clinic_ai/app/modules/(home)/onboarding_page/views/onboarding_page_view.dart';
import 'package:clinic_ai/app/modules/(home)/personal_data/bindings/personal_data_binding.dart';
import 'package:clinic_ai/app/modules/(home)/personal_data/views/personal_data_view.dart';
import 'package:clinic_ai/app/modules/(home)/splash_screen/bindings/splash_screen_binding.dart';
import 'package:clinic_ai/app/modules/(home)/splash_screen/views/splash_screen_view.dart';
import 'package:clinic_ai/app/modules/(home)/verification/bindings/verification_binding.dart';
import 'package:clinic_ai/app/modules/(home)/verification/views/verification_view.dart';
import 'package:clinic_ai/app/modules/(home)/verificationSuccess/bindings/verification_success_binding.dart';
import 'package:clinic_ai/app/modules/(home)/verificationSuccess/views/verification_success_view.dart';
import 'package:get/get.dart';

import '../modules/(home)/appointment/bindings/appointment_binding.dart';
import '../modules/(home)/appointment/views/appointment_view.dart';
import '../modules/(home)/barcodeAppointment/bindings/barcode_appointment_binding.dart';
import '../modules/(home)/barcodeAppointment/views/barcode_appointment_view.dart';
import '../modules/(home)/captureAppointment/bindings/capture_appointment_binding.dart';
import '../modules/(home)/captureAppointment/views/capture_appointment_view.dart';
import '../modules/(home)/scheduleAppointment/bindings/schedule_appointment_binding.dart';
import '../modules/(home)/scheduleAppointment/views/schedule_appointment_view.dart';
import '../modules/(home)/symptomAppointment/bindings/symptom_appointment_binding.dart';
import '../modules/(home)/symptomAppointment/views/symptom_appointment_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

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
      name: _Paths.APPOINTMENT,
      page: () =>  AppointmentView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: _Paths.SCHEDULE_APPOINTMENT,
      page: () => const ScheduleAppointmentView(),
      binding: ScheduleAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.BARCODE_APPOINTMENT,
      page: () => const BarcodeAppointmentView(),
      binding: BarcodeAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.SYMPTOM_APPOINTMENT,
      page: () => const SymptomAppointmentView(),
      binding: SymptomAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.CAPTURE_APPOINTMENT,
      page: () => const CaptureAppointmentView(),
      binding: CaptureAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PANEL,
      page: () => const AdminPanelView(),
      binding: AdminPanelBinding(),
    ),
  ];
}
