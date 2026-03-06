import 'dart:convert'; // Wajib untuk jsonEncode & jsonDecode
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Import http

class ClinicController extends GetxController {
  // URL Backend Vercel Anda
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  RxList<Clinic> clinics = <Clinic>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dgetClinics();
  }

  // --- GET ALL CLINICS ---
  Future<void> dgetClinics() async {
    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/clinics');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 1. Decode dulu sebagai dynamic biar tidak crash
        final dynamic decodedBody = json.decode(response.body);

        List<dynamic> listData = [];

        // 2. Cek tipe datanya
        if (decodedBody is List) {
          // Kasus A: Backend return langsung array [...]
          listData = decodedBody;
        } else if (decodedBody is Map<String, dynamic>) {
          // Kasus B: Backend return object { "data": [...], "result": [...] }
          // Cek key yang mungkin dipakai
          if (decodedBody.containsKey('data') && decodedBody['data'] is List) {
            listData = decodedBody['data'];
          } else if (decodedBody.containsKey('result') &&
              decodedBody['result'] is List) {
            listData = decodedBody['result'];
          } else {
            // Fallback kalau format tidak dikenal, ambil values-nya saja atau kosong
            print("Warning: Format JSON tidak dikenali sebagai List");
          }
        }

        // 3. Mapping ke Model
        clinics.value = listData.map((json) => Clinic.fromJson(json)).toList();
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        Get.snackbar(
            'Error', 'Failed to fetch clinics: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar('Error', 'Failed to fetch clinics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- CREATE CLINIC ---
  Future<void> addClinics(Clinic clinic) async {
    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/clinics');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Header wajib untuk NestJS
        },
        body: json.encode(clinic.toJson()), // Encode object ke JSON String
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await dgetClinics(); // Refresh data
        Get.snackbar('Success', 'Clinic added successfully');
      } else {
        print("Error Add: ${response.body}");
        Get.snackbar('Error', 'Failed to add clinic: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Add: $e");
      Get.snackbar('Error', 'Failed to add clinic: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- UPDATE CLINIC ---
  Future<void> updateClinics(Clinic clinic) async {
    try {
      isLoading.value = true;

      // ID dikirim di URL
      final url = Uri.parse('$baseUrl/clinics/${clinic.id}');

      final response = await http.patch(
        // Gunakan PATCH sesuai Controller NestJS
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(clinic.toJson()),
      );

      if (response.statusCode == 200) {
        await dgetClinics(); // Refresh list
        Get.snackbar('Success', 'Clinic updated successfully');
      } else {
        print("Error Update: ${response.body}");
        Get.snackbar(
            'Error', 'Failed to update clinic: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Update: $e");
      Get.snackbar('Error', 'Failed to update clinic: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- DELETE CLINIC ---
  Future<void> deleteClinics(String id) async {
    try {
      isLoading.value = true;

      final url = Uri.parse('$baseUrl/clinics/$id');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        await dgetClinics(); // Refresh list
        Get.snackbar('Success', 'Clinic deleted successfully');
      } else {
        print("Error Delete: ${response.body}");
        Get.snackbar(
            'Error', 'Failed to delete clinic: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Delete: $e");
      Get.snackbar('Error', 'Failed to delete clinic: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
