  import 'dart:convert';

  import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
  import 'package:clinic_ai/app/routes/app_pages.dart';
  import 'package:clinic_ai/models/appointment_model.dart';
  import 'package:clinic_ai/models/user_model.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:google_sign_in/google_sign_in.dart';
  import 'package:http/http.dart' as http;
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
    RxList<Appointment> medicalRecords =
        <Appointment>[].obs; // List observable untuk medical records
    RxBool isLoadingMedicalRecords = false.obs;

    //Drugs
    RxList<dynamic> drugs = <dynamic>[].obs;
    RxBool isLoadingDrugs = false.obs;

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
      // checkExistingAppointment();
      fetchMedicalRecords();
      fetchDrugs();
      final prefs = await SharedPreferences.getInstance();
      currentLanguage.value = prefs.getString(LANGUAGE_KEY) ?? 'id';
      isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    }

    Future<void> fetchDrugs() async {
      isLoadingDrugs.value = true;
      try {
        // 1. Ambil token dari SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('accessToken');

        // 2. Jika token tidak ada, arahkan kembali ke Login atau tampilkan pesan
        if (token == null || token.isEmpty) {
          print('Error: Token JWT tidak ditemukan, silakan login ulang.');
          return;
        }

        final String url = 'https://be-clinic-rx7y.vercel.app/drugs';

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            // 3. Masukkan token ke header Authorization dengan format Bearer
            'Authorization': 'Bearer $token',
          },
        );

        print('Fetch Drugs Status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData['success'] == true && responseData['data'] is List) {
            drugs.assignAll(responseData['data']);
            print('Berhasil memuat ${drugs.length} obat secara aman');
          }
        } else if (response.statusCode == 401) {
          // Jika token tidak valid atau expired, paksa logout
          print('Error: Sesi berakhir (401).');
          logout();
        }
      } catch (e) {
        print('Error Fetch Drugs: $e');
      } finally {
        isLoadingDrugs.value = false;
      }
    }

    Future<void> fetchMedicalRecords() async {
      isLoadingMedicalRecords.value = true;
      try {
        final prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('accessToken');

        if (token == null) {
          print('Error: Token tidak ditemukan');
          return;
        }

        // Pastikan URL ini sesuai controller NestJS Anda.
        // Jika error 404, ganti jadi: .../appointments/my-appointments
        final String url = 'https://be-clinic-rx7y.vercel.app/appointments';

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        print('Status Code: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          
          // Handle format interceptor { data: [...] }
          final List<dynamic> rawData = responseData['data'] ?? [];

          final List<Appointment> safeList = [];

          // LOOPING AMAN (ANTI CRASH)
          for (var item in rawData) {
            try {
              safeList.add(Appointment.fromJson(item));
            } catch (e) {
              // Jika ada data busuk, kita skip dan log error-nya saja, jangan bikin app mati
              print("⚠️ Skip data error ID ${item['id']}: $e"); 
            }
          }

          medicalRecords.assignAll(safeList);
          print('✅ Berhasil fetch ${medicalRecords.length} medical records');
        } else {
          print('❌ Gagal fetch: ${response.body}');
        }
      } catch (e) {
        print('❌ Error fetching medical records global: $e');
      } finally {
        isLoadingMedicalRecords.value = false;
      }
    }

    void viewMedicalReport(String appointmentId) {
      // Arahkan ke halaman khusus laporan medis atau
      // panggil fungsi download PDF yang kita buat tadi
      Get.toNamed(Routes.SUMMARY_APPOINTMENT, arguments: appointmentId);
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
          // PERBAIKAN: Gunakan .maybeSingle() agar mengembalikan Map tunggal, bukan List
          final response = await supabase
              .from('appointments')
              .select()
              .eq('user_id', userId)
              .eq('status', 1)
              .maybeSingle();

          if (response != null) {
            existingAppointment.value = Appointment.fromJson(response);
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
          existingDoctor.value =
              null; // Ensure existingDoctor is null if doctor not found
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
      print(
          'Navigating for Appointment ID: ${appointment.id} with status: ${appointment.status}');

      switch (appointment.status) {
        case 1: // Waiting
        case 2: // Approved
        case 4: // Diagnose
        case 5: // Unpaid (Menunggu hasil/pembayaran)
        case 7: // Completed
          // SEMUA status di atas langsung arahkan ke SUMMARY
          Get.toNamed(Routes.SUMMARY_APPOINTMENT, arguments: appointment.id);
          break;

        case 6: // Waiting for Drugs
          Get.toNamed(Routes.REDEEM_MEDICINE, arguments: appointment.id);
          break;

        case 3: // Rejected
          Get.snackbar('Info',
              'This appointment was rejected: ${appointment.rejectedNote ?? ""}',
              backgroundColor: Colors.red, colorText: Colors.white);
          break;

        default:
          // Jika status aneh atau belum ada data, baru ke halaman Appointment awal
          Get.toNamed(Routes.APPOINTMENT,
              parameters: {'appointmentId': appointment.id});
          break;
      }
    }
  }
