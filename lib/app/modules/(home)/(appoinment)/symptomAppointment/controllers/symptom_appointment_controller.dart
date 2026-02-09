import 'dart:convert';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';

class SymptomAppointmentController extends GetxController {
  // URL Backend lu di Vercel
  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  RxList<Symptom> symptoms = <Symptom>[].obs;
  RxList<String> selectedSymptomIds = <String>[].obs;
  RxMap<String, bool> isSymptomSelected = <String, bool>{}.obs;

  RxBool isLoading = false.obs;
  RxString symptomDescription = ''.obs;
  RxBool isDescriptionValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Fetch data master gejala dari BE
    fetchSymptoms();

    // Listener untuk validasi tombol next
    symptomDescription.listen((value) {
      isDescriptionValid.value = value.isNotEmpty;
    });
  }

  // --- HELPER: AMBIL HEADER AUTH ---
  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // --- API 1: FETCH SYMPTOMS (GET) ---
  Future<void> fetchSymptoms() async {
    isLoading(true);
    try {
      final barcodeController = Get.find<BarcodeAppointmentController>();
      final appointment = barcodeController.currentAppointment.value;

      if (appointment == null) {
        print("DEBUG: Appointment null, fetch dibatalkan.");
        symptoms.clear();
        return;
      }

      final headers = await getHeaders();
      final url = '$baseUrl/masters/symptoms/${appointment.polyId}';

      print("DEBUG: Fetching Symptoms...");
      print("URL: $url");

      final response = await http.get(Uri.parse(url), headers: headers);

      print("STATUS CODE: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse;

        print("DATA RECEIVED: ${data.length} symptoms found.");
        symptoms.assignAll(data.map((e) => Symptom.fromJson(e)).toList());

        isSymptomSelected.value = {
          for (var symptom in symptoms) symptom.id: false
        };

        loadExistingSymptoms();
      } else {
        print("ERROR BODY: ${response.body}");
      }
    } catch (error) {
      print("CATCH ERROR (Fetch): $error");
    } finally {
      isLoading(false);
    }
  }

  // --- LOGIC: MAP DATA LAMA DARI APPOINTMENT ---
  void loadExistingSymptoms() {
    try {
      final barcodeController = Get.find<BarcodeAppointmentController>();
      final appointment = barcodeController.currentAppointment.value;

      if (appointment != null && appointment.symptoms != null) {
        final existingSymptoms = appointment.symptoms!.split(',');

        selectedSymptomIds.clear();
        for (var symptomId in existingSymptoms) {
          if (symptomId.isNotEmpty) {
            isSymptomSelected[symptomId] = true;
            selectedSymptomIds.add(symptomId);
          }
        }

        if (appointment.symptomDescription != null) {
          symptomDescription.value = appointment.symptomDescription!;
        }

        isSymptomSelected.refresh();
        selectedSymptomIds.refresh();
      }
    } catch (error) {
      print("Error loading existing symptoms: $error");
    }
  }

  // --- API 2: UPDATE APPOINTMENT SYMPTOMS (PATCH) ---
  Future<void> updateAppointment() async {
    if (selectedSymptomIds.isEmpty || symptomDescription.value.isEmpty) {
      Get.snackbar('Error', 'Pilih minimal satu gejala dan isi deskripsi.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading(true);
    try {
      final barcodeController = Get.find<BarcodeAppointmentController>();
      final appointment = barcodeController.currentAppointment.value;

      if (appointment == null) {
        print("DEBUG: Update gagal, appointment null.");
        return;
      }

      final headers = await getHeaders();
      final url = '$baseUrl/appointments/${appointment.id}/symptoms';
      final symptomString = selectedSymptomIds.join(',');
      final body = json.encode({
        'symptoms': symptomString,
        'symptom_description': symptomDescription.value,
      });

      print("DEBUG: Updating Appointment Symptoms...");
      print("PATCH URL: $url");
      print("PAYLOAD: $body");

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print("PATCH STATUS: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("SUCCESS: Data updated on server.");
        barcodeController.currentAppointment.value = appointment.copyWith(
          symptoms: symptomString,
          symptomDescription: symptomDescription.value,
          status: 1,
        );
        barcodeController.isSymptomsUpdated.value = true;
        Get.snackbar('Berhasil', 'Gejala berhasil diperbarui!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print("PATCH FAILED: ${response.body}");
        throw 'Gagal update: ${response.body}';
      }
    } catch (error) {
      print("CATCH ERROR (Update): $error");
      Get.snackbar('Error', 'Gagal memperbarui janji temu: $error');
    } finally {
      isLoading(false);
    }
  }

  void toggleSymptom(String symptomId) {
    if (selectedSymptomIds.contains(symptomId)) {
      selectedSymptomIds.remove(symptomId);
      isSymptomSelected[symptomId] = false;
    } else {
      selectedSymptomIds.add(symptomId);
      isSymptomSelected[symptomId] = true;
    }
    isSymptomSelected.refresh();
    selectedSymptomIds.refresh();
  }

  void updateSymptomDescription(String value) {
    symptomDescription.value = value;
  }

  void reset() {
    selectedSymptomIds.clear();
    isSymptomSelected.value = {for (var symptom in symptoms) symptom.id: false};
    symptomDescription.value = '';
    isDescriptionValid.value = false;
    selectedSymptomIds.refresh();
    isSymptomSelected.refresh();
  }
}
