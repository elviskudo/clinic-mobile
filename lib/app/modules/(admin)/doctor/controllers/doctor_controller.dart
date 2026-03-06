import 'dart:convert';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DoctorController extends GetxController {
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  RxList<Doctor> doctors = <Doctor>[].obs;
  RxList<Users> users = <Users>[].obs;
  RxList<Clinic> clinics = <Clinic>[].obs;
  RxList<Poly> polies = <Poly>[].obs;

  RxBool isLoading = false.obs;

  var selectedClinicId = ''.obs;
  var selectedPolyId = ''.obs;
  var selectedUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  void loadAllData() async {
    await getDoctors();
    await getClinics();
    await getPolies();
    await getUsers();
  }

  List<dynamic> _parseListResponse(dynamic decodedBody) {
    if (decodedBody is List) return decodedBody;
    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody['data'] is List) return decodedBody['data'];
      if (decodedBody['result'] is List) return decodedBody['result'];
      if (decodedBody['result'] is Map &&
          decodedBody['result']['data'] is List) {
        return decodedBody['result']['data'];
      }
    }
    return [];
  }

  // --- 1. GET DOCTORS (FIX SANITASI ID) ---
  Future<void> getDoctors() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/doctors'));

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        doctors.value = data.map((item) {
          if (item is Map<String, dynamic>) {
            // FIX: Pastikan ID tidak null
            item['id'] ??= '';
            item['name'] ??= 'Unknown';
            item['degree'] ??= '';
            item['description'] ??= '';
            item['specialize'] ??= '';
            // ... field lain
          }
          return Doctor.fromJson(item);
        }).toList();

        // Debug: Cek apakah ID ada
        if (doctors.isNotEmpty) {
          print("First Doctor ID: ${doctors[0].id}");
        }
      }
    } catch (e) {
      print("Error fetching doctors: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ... (Get Users, Clinics, Polies tetap sama) ...
  Future<void> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);
        users.value = data.map((item) => Users.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error Users: $e");
    }
  }

  Future<void> getClinics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clinics'));
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);
        clinics.value = data.map((item) => Clinic.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error Clinics: $e");
    }
  }

  Future<void> getPolies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/polies'));
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);
        polies.value = data.map((item) => Poly.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error Polies: $e");
    }
  }

  // --- 5. ADD DOCTOR ---
  Future<void> addDoctor(Doctor doctor) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('$baseUrl/doctors'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(doctor.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getDoctors();
        Get.snackbar('Success', 'Doctor added successfully');
      } else {
        print("Error Add: ${response.body}");
        Get.snackbar('Error', 'Failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 6. UPDATE DOCTOR (FIX URL 404) ---
  Future<void> updateDoctor(Doctor doctor) async {
    // 1. Validasi Awal: Pastikan ID tidak kosong
    if (doctor.id.isEmpty) {
      Get.snackbar('Error', 'ID Dokter tidak valid (Kosong)',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // DEBUG: Cek URL dan Data yang dikirim di Console
      print("🔵 Request UPDATE ke: $baseUrl/doctors/${doctor.id}");
      print("📦 Data dikirim (Payload): ${json.encode(doctor.toJson())}");

      final response = await http.patch(
        Uri.parse('$baseUrl/doctors/${doctor.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(doctor.toJson()),
      );

      print("🟡 Status Code: ${response.statusCode}");
      print("🟡 Response Body: ${response.body}");

      // 2. Handle Response
      if (response.statusCode == 200) {
        // SUKSES
        await getDoctors(); // Refresh list di halaman utama
        Get.back(); // Tutup dialog edit otomatis
        Get.snackbar('Berhasil', 'Data dokter berhasil diperbarui',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // GAGAL: Parsing pesan error dari Backend NestJS
        // Backend mengirim: { "message": "...", "error": "...", "statusCode": ... }
        final errorBody = json.decode(response.body);
        String errorMessage = errorBody['message'] ?? 'Gagal update data';

        // Kadang message berupa List (dari validasi DTO), kita ambil yang pertama
        if (errorBody['message'] is List) {
          errorMessage = errorBody['message'].join(', ');
        }

        Get.snackbar('Gagal Update', errorMessage,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4));
      }
    } catch (e) {
      print("❌ Exception Update: $e");
      Get.snackbar('Error Aplikasi', 'Terjadi kesalahan koneksi: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 7. DELETE DOCTOR ---
  Future<void> deleteDoctor(String id) async {
    if (id.isEmpty) return; // Prevent empty delete

    try {
      isLoading.value = true;
      final response = await http.delete(Uri.parse('$baseUrl/doctors/$id'));

      if (response.statusCode == 200) {
        await getDoctors();
        Get.snackbar('Success', 'Doctor deleted successfully');
      } else {
        print("Error Delete: ${response.body}");
        Get.snackbar('Error', 'Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }
}
