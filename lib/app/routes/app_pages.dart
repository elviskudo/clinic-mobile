import 'package:get/get.dart';

import '../modules/(admin)/admin_panel/bindings/admin_panel_binding.dart';
import '../modules/(admin)/admin_panel/views/admin_panel_view.dart';
import '../modules/(admin)/clinic/bindings/clinic_binding.dart';
import '../modules/(admin)/clinic/views/clinic_view.dart';
import '../modules/(admin)/doctor/bindings/doctor_binding.dart';
import '../modules/(admin)/doctor/views/doctor_view.dart';
import '../modules/(admin)/drug_admin/bindings/drug_admin_binding.dart';
import '../modules/(admin)/drug_admin/views/drug_admin_view.dart';
import '../modules/(admin)/list_user/bindings/list_user_binding.dart';
import '../modules/(admin)/list_user/views/list_user_view.dart';
import '../modules/(admin)/poly/bindings/poly_binding.dart';
import '../modules/(admin)/poly/views/poly_view.dart';
import '../modules/(auth)/login/bindings/login_binding.dart';
import '../modules/(auth)/login/views/login_view.dart';
import '../modules/(auth)/verification/bindings/verification_binding.dart';
import '../modules/(auth)/verification/views/verification_view.dart';
import '../modules/(auth)/verificationSuccess/bindings/verification_success_binding.dart';
import '../modules/(auth)/verificationSuccess/views/verification_success_view.dart';
import '../modules/(doctor)/detail-diagnose/bindings/detail_diagnose_binding.dart';
import '../modules/(doctor)/detail-diagnose/views/detail_diagnose_view.dart';
import '../modules/(doctor)/home_doctor/bindings/home_doctor_binding.dart';
import '../modules/(doctor)/home_doctor/views/home_doctor_view.dart';
import '../modules/(doctor)/list_patients/bindings/list_patients_binding.dart';
import '../modules/(doctor)/list_patients/views/list_patients_view.dart';
import '../modules/(doctor)/qr_scanner_screen/bindings/qr_scanner_screen_binding.dart';
import '../modules/(doctor)/qr_scanner_screen/views/qr_scanner_screen_view.dart';
import '../modules/(home)/(appoinment)/appointment/bindings/appointment_binding.dart';
import '../modules/(home)/(appoinment)/appointment/views/appointment_view.dart';
import '../modules/(home)/(appoinment)/barcodeAppointment/bindings/barcode_appointment_binding.dart';
import '../modules/(home)/(appoinment)/barcodeAppointment/views/barcode_appointment_view.dart';
import '../modules/(home)/(appoinment)/captureAppointment/bindings/capture_appointment_binding.dart';
import '../modules/(home)/(appoinment)/captureAppointment/views/capture_appointment_view.dart';
import '../modules/(home)/(appoinment)/scheduleAppointment/bindings/schedule_appointment_binding.dart';
import '../modules/(home)/(appoinment)/scheduleAppointment/views/schedule_appointment_view.dart';
import '../modules/(home)/(appoinment)/summaryAppointment/bindings/summary_appointment_binding.dart';
import '../modules/(home)/(appoinment)/summaryAppointment/views/summary_appointment_view.dart';
import '../modules/(home)/(appoinment)/symptomAppointment/bindings/symptom_appointment_binding.dart';
import '../modules/(home)/(appoinment)/symptomAppointment/views/symptom_appointment_view.dart';
import '../modules/(home)/about_app/bindings/about_app_binding.dart';
import '../modules/(home)/about_app/views/about_app_view.dart';
import '../modules/(home)/account_settings/bindings/account_settings_binding.dart';
import '../modules/(home)/account_settings/views/account_settings_view.dart';
import '../modules/(home)/help_center/bindings/help_center_binding.dart';
import '../modules/(home)/help_center/views/help_center_view.dart';
import '../modules/(home)/home/bindings/home_binding.dart';
import '../modules/(home)/home/views/home_view.dart';
import '../modules/(home)/medicalHistory/bindings/medical_history_binding.dart';
import '../modules/(home)/medicalHistory/views/medical_history_view.dart';
import '../modules/(home)/medicineRecord/bindings/medicine_record_binding.dart';
import '../modules/(home)/medicineRecord/views/medicine_record_view.dart';
import '../modules/(home)/onboarding_page/bindings/onboarding_page_binding.dart';
import '../modules/(home)/onboarding_page/views/onboarding_page_view.dart';
import '../modules/(home)/personal_data/bindings/personal_data_binding.dart';
import '../modules/(home)/personal_data/views/personal_data_view.dart';
import '../modules/(home)/profile/bindings/profile_binding.dart';
import '../modules/(home)/profile/views/profile_view.dart';
import '../modules/(home)/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/(home)/splash_screen/views/splash_screen_view.dart';
import '../modules/notification-user/bindings/notification_user_binding.dart';
import '../modules/notification-user/views/notification_user_view.dart';
import '../modules/(home)/redeemMedicine/bindings/redeem_medicine_binding.dart';
import '../modules/(home)/redeemMedicine/views/redeem_medicine_view.dart';
import '../modules/(home)/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/(home)/splash_screen/views/splash_screen_view.dart';
import '../modules/(doctor)/appointment-result/bindings/appointment_result_binding.dart';
import '../modules/(doctor)/appointment-result/views/appointment_result_view.dart';
import '../modules/notification-user/bindings/notification_user_binding.dart';
import '../modules/notification-user/views/notification_user_view.dart';

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
      name: _Paths.APPOINTMENT,
      page: () => AppointmentView(),
      binding: AppointmentBinding(),
    ),
    // GetPage(
    //   name: _Paths.SCHEDULE_APPOINTMENT,
    //   page: () =>  ScheduleAppointmentView(tabController: null,),
    //   binding: ScheduleAppointmentBinding(),
    // ),
    GetPage(
      name: _Paths.BARCODE_APPOINTMENT,
      page: () => const BarcodeAppointmentView(),
      binding: BarcodeAppointmentBinding(),
    ),
    // GetPage(
    //   name: _Paths.SYMPTOM_APPOINTMENT,
    //   page: () => const SymptomAppointmentView(),
    //   binding: SymptomAppointmentBinding(),
    // ),
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

    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: _Paths.LIST_PATIENTS,
      page: () => const ListPatientsView(),
      binding: ListPatientsBinding(),
    ),
    GetPage(
      name: _Paths.QR_SCANNER_SCREEN,
      page: () => const QrScannerScreenView(),
      binding: QrScannerScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME_DOCTOR,
      page: () => const HomeDoctorView(),
      binding: HomeDoctorBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_USER,
      page: () => const NotificationUserView(),
      binding: NotificationUserBinding(),
    ),
    GetPage(
      name: _Paths.SUMMARY_APPOINTMENT,
      page: () => const SummaryAppointmentView(),
      binding: SummaryAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.HELP_CENTER,
      page: () => HelpCenterView(),
      binding: HelpCenterBinding(),
    ),
    GetPage(
      name: _Paths.MEDICINE_RECORD,
      page: () => const MedicineRecordView(),
      binding: MedicineRecordBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_APP,
      page: () => const AboutAppView(),
      binding: AboutAppBinding(),
    ),
    GetPage(
        name: _Paths.DETAIL_DIAGNOSE,
        page: () => const DetailDiagnoseView(),
        binding: DetailDiagnoseBinding()),
    GetPage(
      name: _Paths.DRUG_ADMIN,
      page: () => const DrugAdminView(),
      binding: DrugAdminBinding(),
    ),
    GetPage(
      name: _Paths.MEDICAL_HISTORY,
      page: () => const MedicalHistoryView(),
      binding: MedicalHistoryBinding(),
    ),
    GetPage(
      name: _Paths.APPOINTMENT_RESULT,
      page: () => const AppointmentResultView(),
      binding: AppointmentResultBinding(),
    ),
    GetPage(
      name: _Paths.REDEEM_MEDICINE,
      page: () => const RedeemMedicineView(),
      binding: RedeemMedicineBinding(),
    ),
  ];
}
