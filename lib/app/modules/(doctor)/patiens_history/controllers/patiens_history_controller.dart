import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PatiensHistoryController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  // Gunakan List<Map<String, dynamic>> agar data JSON mudah dibaca di UI
  final historyList = <Map<String, dynamic>>[].obs;

  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  @override
  void onInit() {
    super.onInit();
    // Tunda pemanggilan fetch untuk menghindari error build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHistory();
    });
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      print('--- MENGAMBIL DATA HISTORY DOKTER ---');
      print('URL: $baseUrl/appointments/doctor/history');

      // Tembak ke endpoint history dokter
      final response = await http.get(
        Uri.parse('$baseUrl/appointments/doctor/history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);

        List<dynamic> rawData = [];

        var targetData = decoded['data'] ?? decoded;

        if (targetData is List) {
          rawData = targetData;
        } else if (targetData is Map) {
          if (targetData.containsKey('data') && targetData['data'] is List) {
            rawData = targetData['data'];
          } else {
            rawData = [targetData];
          }
        }

        print('JUMLAH DATA MENTAH DARI BACKEND: ${rawData.length}');

        historyList.value = rawData
            .map((e) {
              if (e is Map) return Map<String, dynamic>.from(e);
              return <String, dynamic>{};
            })
            .where((e) => e.isNotEmpty)
            .toList();

        print('JUMLAH DATA SETELAH DI PARSING: ${historyList.length}');

        if (decoded is Map && decoded['success'] == false) {
          errorMessage.value =
              decoded['message'] ?? 'Gagal memuat riwayat pasien';
        }
      } else {
        errorMessage.value =
            'Terjadi kesalahan server (${response.statusCode})';
      }
    } catch (e) {
      print('ERROR CATCH: $e');
      errorMessage.value = 'Terjadi kesalahan jaringan: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
