import 'package:clinic_ai/models/symptom_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';

class SymptomAppointmentController extends GetxController {
  RxList<Symptom> symptoms = <Symptom>[].obs;
  RxList<String> selectedSymptomIds = <String>[].obs;
  RxMap<String, bool> isSymptomSelected = <String, bool>{}.obs;

  final supabase = Supabase.instance.client;
  RxBool isLoading = false.obs;

  RxString symptomDescription = ''.obs; // Deskripsi gejala
  RxBool isDescriptionValid = false.obs; // Validasi deskripsi

  @override
  void onInit() {
    super.onInit();
    fetchSymptoms();

    // Listener untuk deskripsi gejala
    symptomDescription.listen((value) {
      isDescriptionValid.value = value.isNotEmpty; // Deskripsi harus tidak kosong
    });
  }

  Future<void> fetchSymptoms() async {
    isLoading(true);
    try {
      final barcodeController = Get.find<BarcodeAppointmentController>();
      final appointment = barcodeController.currentAppointment.value;

      if (appointment == null) {
        print("Tidak ada appointment yang tersedia.");
        symptoms.value = [];
        return;
      }

      final polyId = appointment.polyId;

      final response = await supabase
          .from('symptoms')
          .select('*')
          .eq('poly_id', polyId);

      print("Response dari Supabase: ${response}");

      if (response != null && response is List) {
        symptoms.value = response.map((e) => Symptom.fromJson(e)).toList();
        isSymptomSelected.value = {for (var symptom in symptoms) symptom.id: false};
        print("Jumlah gejala yang ditemukan: ${symptoms.length}");
      } else {
        print("Error fetching symptoms: ${response}");
      }
    } catch (error) {
      print("Error fetching symptoms: $error");
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

  // Fungsi untuk memperbarui deskripsi gejala
  void updateSymptomDescription(String value) {
    symptomDescription.value = value;
  }

  // Fungsi untuk memperbarui data appointment di Supabase
  Future<void> updateAppointment() async {
    // Validasi: Pastikan gejala dipilih DAN deskripsi tidak kosong
    if (selectedSymptomIds.isEmpty || symptomDescription.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one symptom and provide a symptom description.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Stop jika validasi gagal
    }

    isLoading(true);
    try {
      final barcodeController = Get.find<BarcodeAppointmentController>();
      final appointment = barcodeController.currentAppointment.value;

      if (appointment == null) {
        Get.snackbar(
          'Error',
          'Appointment not found.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final symptomString = selectedSymptomIds.join(','); // Gabungkan ID dengan koma
      final description = symptomDescription.value;

      await supabase
          .from('appointments')
          .update({
        'symptoms': symptomString,
        'symptom_description': description,
      
      })
          .eq('id', appointment.id);

       // Perbarui state di BarcodeAppointmentController
    barcodeController.currentAppointment.value = appointment.copyWith(
      symptoms: symptomString,
      symptomDescription: description,
      status: 1,
    );

    // Tandai bahwa gejala sudah diupdate
    barcodeController.isSymptomsUpdated.value = true;

      Get.snackbar(
        'Success',
        'Appointment updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to update appointment: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}