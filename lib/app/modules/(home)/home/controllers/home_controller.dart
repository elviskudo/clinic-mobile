 import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
  import 'package:clinic_ai/app/routes/app_pages.dart';
  import 'package:clinic_ai/models/appointment_model.dart';
  import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:google_sign_in/google_sign_in.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';
  import 'package:translator/translator.dart';
  import 'package:intl/intl.dart'; // Import intl
  import 'package:clinic_ai/models/doctor_model.dart';
  import 'package:clinic_ai/models/poly_model.dart';
  import 'package:clinic_ai/models/scheduleDate_model.dart';
  import 'package:clinic_ai/models/scheduleTime_model.dart';
  import 'package:clinic_ai/models/clinic_model.dart'; // Import Clinic Model

  class HomeController extends GetxController {
    static const String LANGUAGE_KEY = 'selected_language';
    final translator = GoogleTranslator();
    var currentLanguage = 'id'.obs;
    var isLoading = false.obs;
    final isLoggedIn = false.obs;
    final user = Users().obs;
    RxList<Appointment> medicalRecords = <Appointment>[].obs; // List observable untuk medical records
    RxBool isLoadingMedicalRecords = false.obs;
    final translations = {
      'createAccount': 'Create an Account'.obs,
      'startDescription':
          'Start with make an account and then you can start to check your health anytime, anywhere!'
              .obs,
      'apple': 'Apple'.obs,
      'google': 'Google'.obs,
      'orByEmail': 'Or by email'.obs,
      'name': 'Name'.obs,
      'fullName': 'Your full name'.obs,
      'email': 'E-mail'.obs,
      'enterEmail': 'Enter your email'.obs,
      'phone': 'No. Telp'.obs,
      'enterPhone': 'Enter a phone number'.obs,
      'password': 'Password'.obs,
      'confirmPassword': 'Confirm Password'.obs,
      'agreeToTerms': 'I agree to the '.obs,
      'termsAndConditions': ' terms and conditions'.obs,
      'register': 'Register'.obs,
      'haveAccount': 'have an account yet? '.obs,
      // 'login': 'Login'.obs,
    };

    final supabase = Supabase.instance.client;
    final hasCreatedAppointment = false.obs;
    final Rxn<Appointment> existingAppointment = Rxn<Appointment>();
    Rxn<Doctor> existingDoctor = Rxn<Doctor>();
    Rxn<Poly> existingPoly = Rxn<Poly>();
    Rxn<ScheduleDate> existingScheduleDate = Rxn<ScheduleDate>();
    Rxn<ScheduleTime> existingScheduleTime = Rxn<ScheduleTime>();
    Rxn<Clinic> existingClinic = Rxn<Clinic>();
    RxString doctorProfilePictureUrl = ''.obs;

    @override
    void onInit() async {
      super.onInit();
      checkExistingAppointment();
      fetchMedicalRecords();
      final prefs = await SharedPreferences.getInstance();
      currentLanguage.value = prefs.getString(LANGUAGE_KEY) ?? 'id';
      isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    }

    Future<void> fetchMedicalRecords() async {
      isLoadingMedicalRecords.value = true;
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');

        if (userId != null) {
          final response = await Supabase.instance.client
              .from('appointments')
              .select('*')
              .eq('user_id', userId)
              .order('created_at', ascending: false);

          if (response != null && response is List) {
            medicalRecords.value =
                response.map((e) => Appointment.fromJson(e)).toList().obs;
          } else {
            print('Failed to fetch medical records: ${response}');
            Get.snackbar('Error', 'Failed to load medical records.');
          }
        }
      } catch (e) {
        print('Error fetching medical records: $e');
        Get.snackbar('Error',
            'Something went wrong while fetching medical records.');
      } finally {
        isLoadingMedicalRecords.value = false;
      }
    }

    String getStatusText(int status) {
      switch (status) {
        case 1:
          return 'Waiting';
        case 2:
          return 'Approved';
        case 3:
          return 'Rejected';
        case 4:
          return 'Diagnose';
        case 5:
          return 'Unpaid';
        case 6:
          return 'Waiting for Drugs';
        case 7:
          return 'Completed';
        default:
          return 'Unknown Status';
      }
    }

    Future<void> _saveLanguage(String languageCode) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LANGUAGE_KEY, languageCode);
    }

    Future<void> logout() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userRole');
      await prefs.remove('userId');
      await GoogleSignIn().signOut();
      isLoggedIn.value = false;
      Get.offAllNamed(Routes.LOGIN);
    }

    Future<void> checkExistingAppointment() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');

        if (userId != null) {
          final response = await supabase
              .from('appointments')
              .select()
              .eq('user_id', userId)
              .eq('status', 1)
              .limit(1);

          if (response != null && response.isNotEmpty) {
            existingAppointment.value = Appointment.fromJson(response.first);
            await fetchRelatedData(existingAppointment.value!);
            hasCreatedAppointment.value = true;

            if (Get.isRegistered<BarcodeAppointmentController>()) {
              final barcodeController = Get.find<BarcodeAppointmentController>();
              barcodeController.setAppointmentData(existingAppointment.value!);
              barcodeController.isAccessible.value = true;
            }
          }
        }
      } catch (e) {
        print('Error checking existing appointment: $e');
      }
    }

    Future<void> fetchRelatedData(Appointment appointment) async {
      try {
        // Fetch Doctor
        final doctorResponse = await supabase
            .from('doctors')
            .select()
            .eq('id', appointment.doctorId)
            .maybeSingle();

        if (doctorResponse != null) {
          existingDoctor.value = Doctor.fromJson(doctorResponse);
          await fetchDoctorProfilePicture(existingDoctor.value!.id!);
        } else {
          existingDoctor.value = null; // Ensure existingDoctor is null if doctor not found
          doctorProfilePictureUrl.value = ''; // Reset profile picture URL
        }
        

        // Fetch Poly
        final polyResponse = await supabase
            .from('polies')
            .select()
            .eq('id', appointment.polyId)
            .maybeSingle();
        existingPoly.value =
            polyResponse != null ? Poly.fromJson(polyResponse) : null;

        // Fetch ScheduleDate
        final scheduleDateResponse = await supabase
            .from('schedule_dates')
            .select()
            .eq('id', appointment.dateId)
            .maybeSingle();
        existingScheduleDate.value = scheduleDateResponse != null
            ? ScheduleDate.fromJson(scheduleDateResponse)
            : null;

        // Fetch ScheduleTime
        final scheduleTimeResponse = await supabase
            .from('schedule_times')
            .select()
            .eq('id', appointment.timeId)
            .maybeSingle();
        existingScheduleTime.value = scheduleTimeResponse != null
            ? ScheduleTime.fromJson(scheduleTimeResponse)
            : null;

        // Fetch Clinic
        final clinicResponse = await supabase
            .from('clinics')
            .select()
            .eq('id', appointment.clinicId)
            .maybeSingle();
        existingClinic.value =
            clinicResponse != null ? Clinic.fromJson(clinicResponse) : null;
      } catch (e) {
        print('Error fetching related data: $e');
      }
    }

    Future<void> fetchDoctorProfilePicture(String userId) async {
      try {
        final fileResponse = await supabase
            .from('files')
            .select('file_name')
            .eq('module_class', 'users')
            .eq('module_id', userId)
            .maybeSingle();

        if (fileResponse != null) {
          doctorProfilePictureUrl.value =
              fileResponse['file_name'] as String? ?? '';
        } else {
          doctorProfilePictureUrl.value = '';
        }
      } catch (e) {
        print('Error fetching doctor profile picture: $e');
        doctorProfilePictureUrl.value = '';
      }
    }

    void setAppointmentCreated(bool value) {
      hasCreatedAppointment.value = value;
    }

    Future<String> translateText(String text, String targetLanguage) async {
      try {
        if (targetLanguage == currentLanguage.value) {
          return text;
        }

        var translation = await translator.translate(
          text,
          from: currentLanguage.value,
          to: targetLanguage,
        );
        return translation.text;
      } catch (e) {
        print('Error translating: $e');
        return text;
      }
    }

    Future<void> updateAllTranslations(
        Map<String, RxString> translations, String targetLanguage) async {
      var previousLanguage = currentLanguage.value;
      isLoading.value = true;

      try {
        final futures = translations.entries
            .map((entry) => translateText(entry.value.value, targetLanguage))
            .toList();

        // Menjalankan semua terjemahan secara bersamaan
        final translatedTexts = await Future.wait(futures);

        // Mengupdate nilai setelah semua terjemahan selesai
        var index = 0;
        for (var entry in translations.entries) {
          translations[entry.key]?.value = translatedTexts[index];
          index++;
        }

        await _saveLanguage(targetLanguage);
        currentLanguage.value = targetLanguage;
      } catch (e) {
        print('Error updating translations: $e');
        currentLanguage.value = previousLanguage;
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> getProfile() async {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        Get.snackbar('Error', 'User ID not found. Please login again.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      String? storedImageUrl = prefs.getString('imageUrl');
      if (storedImageUrl == null || storedImageUrl.isEmpty) {
        print('imageUrl is empty or not set');
      } else {
        print('imageUrl found: $storedImageUrl');
      }
      user.value = Users(
        name: prefs.getString('name') ?? 'Guest User',
      );
      print('user.name: ${user.value.name}');
    }
    final RxInt currentIndex = 0.obs;

  // Method to update the current index
  void updateIndex(int index) {
    currentIndex.value = index;
  }
  void navigateToAppointmentDetail1(Appointment appointment) {
    switch (appointment.status) {
      case 1:
        Get.toNamed(Routes.APPOINTMENT, parameters: {'appointmentId': appointment.id}); // Kirim semua data yang diperlukan ke halaman appointment
        break;
      case 2:
      case 4:
      case 5:
        Get.toNamed(Routes.SUMMARY_APPOINTMENT, arguments: appointment.id);
        break;
      case 6:
        Get.toNamed(Routes.REDEEM_MEDICINE, arguments: appointment.id); // Replace with your redeem medicine route
        break;
      case 7:
      case 3:
        // Tampilkan pesan kesalahan atau lakukan sesuatu yang lain
        Get.snackbar('Info', 'This appointment is disabled.', backgroundColor: Colors.red);
        break;
      default:
        Get.snackbar('Info', 'Invalid appointment status.');
        break;
    }
  }
  }