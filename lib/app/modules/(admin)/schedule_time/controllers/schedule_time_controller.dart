import 'dart:convert';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Ganti Supabase dengan Http

class ScheduleTimeController extends GetxController {
  // URL Backend Vercel
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  RxList<ScheduleTime> scheduleTimes = <ScheduleTime>[].obs;
  RxList<ScheduleDate> scheduleDates = <ScheduleDate>[].obs;
  
  RxBool isLoading = false.obs;
  var selectedDateId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load dates dulu, baru times
    getScheduleDates().then((_) => getScheduleTimes());
  }

  // --- HELPER: Smart JSON Parser ---
  List<dynamic> _parseListResponse(dynamic decodedBody) {
    if (decodedBody is List) return decodedBody;
    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody['data'] is List) return decodedBody['data'];
      if (decodedBody['result'] is List) return decodedBody['result'];
    }
    return [];
  }

  // --- 1. GET SCHEDULE DATES (Untuk Dropdown & Validasi) ---
  Future<void> getScheduleDates() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/schedule-dates'));

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        scheduleDates.value = data
            .map((item) => ScheduleDate.fromJson(item))
            .toList();

        // Set default selectedDateId jika ada data dan belum dipilih
        if (selectedDateId.value.isEmpty && scheduleDates.isNotEmpty) {
          selectedDateId.value = scheduleDates[0].id;
        }
      } else {
        print("Error fetching schedule dates: ${response.body}");
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch schedule dates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. GET SCHEDULE TIMES ---
  Future<void> getScheduleTimes() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/schedule-times'));

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        final loadedTimes = data
            .map((item) => ScheduleTime.fromJson(item))
            .toList();

        // Filter: Hanya tampilkan waktu yang ID Tanggalnya valid (ada di list scheduleDates)
        // Ini menjaga konsistensi UI seperti kode lama Anda
        scheduleTimes.value = loadedTimes
            .where((time) => scheduleDates.any((date) => date.id == time.dateId))
            .toList();
            
      } else {
        print("Error fetching schedule times: ${response.body}");
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch schedule times: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 3. ADD SCHEDULE TIME ---
  Future<void> addScheduleTime(ScheduleTime scheduleTime) async {
    // Validasi Date ID di sisi Client
    if (!scheduleDates.any((date) => date.id == scheduleTime.dateId)) {
      Get.snackbar('Error', 'Invalid schedule date reference', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/schedule-times');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(scheduleTime.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getScheduleTimes(); // Refresh
        Get.snackbar('Success', 'Schedule time added successfully');
      } else {
        print("Error Add: ${response.body}");
        Get.snackbar('Error', 'Failed to add: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. UPDATE SCHEDULE TIME ---
  Future<void> updateScheduleTime(ScheduleTime scheduleTime) async {
    if (!scheduleDates.any((date) => date.id == scheduleTime.dateId)) {
      Get.snackbar('Error', 'Invalid schedule date reference', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/schedule-times/${scheduleTime.id}');

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(scheduleTime.toJson()),
      );

      if (response.statusCode == 200) {
        await getScheduleTimes(); 
        Get.snackbar('Success', 'Schedule time updated successfully');
      } else {
        print("Error Update: ${response.body}");
        Get.snackbar('Error', 'Failed to update: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 5. DELETE SCHEDULE TIME ---
  Future<void> deleteScheduleTime(String id) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/schedule-times/$id');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        await getScheduleTimes();
        Get.snackbar('Success', 'Schedule time deleted successfully');
      } else {
        print("Error Delete: ${response.body}");
        Get.snackbar('Error', 'Failed to delete: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}