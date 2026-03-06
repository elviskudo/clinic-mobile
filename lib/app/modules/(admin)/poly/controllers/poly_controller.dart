import 'dart:convert';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Ganti Supabase dengan Http

class PolyController extends GetxController {
  // URL Backend
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  RxList<Poly> polies = <Poly>[].obs;
  RxList<Clinic> clinics = <Clinic>[].obs;

  RxBool isLoading = false.obs;
  var selectedClinicId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPolies();
    getClinics();
  }

  // --- HELPER: Smart JSON Parser ---
  List<dynamic> _parseListResponse(dynamic decodedBody) {
    if (decodedBody is List) return decodedBody;

    if (decodedBody is Map<String, dynamic>) {
      // Cek key 'data' (standar response)
      if (decodedBody.containsKey('data') && decodedBody['data'] is List) {
        return decodedBody['data'];
      }
      // Cek key 'result' (pagination/custom wrapper)
      if (decodedBody.containsKey('result')) {
        if (decodedBody['result'] is List) return decodedBody['result'];
        if (decodedBody['result'] is Map &&
            decodedBody['result']['data'] is List) {
          return decodedBody['result']['data'];
        }
      }
    }
    return [];
  }

  // --- 1. GET POLIES (Updated with Logs) ---
  Future<void> getPolies() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/polies'));

      print("GET Polies Status: ${response.statusCode}"); // Debug Log
      // print("GET Polies Body: ${response.body}"); // Uncomment jika perlu liat raw JSON

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        print("Parsed Data Length: ${data.length}"); // Debug Log
        print("Sample Parsed Item: ${data.isNotEmpty ? data[0] : 'No data'}"); // Debug Log
        print("data: $data");
        

        polies.value = data.map((item) {
          // Sanitasi data agar tidak null
          if (item is Map<String, dynamic>) {
            item['description'] ??= '';
            item['status'] ??= 1;
            item['clinic_id'] ??= '';
          }
          return Poly.fromJson(item);
        }).toList();
      } else {
        print("Error Get Polies: ${response.body}");
      }
    } catch (e) {
      print("Exception Get Polies: $e");
      Get.snackbar('Error', 'Failed to fetch polies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. GET CLINICS (Untuk Dropdown) ---
  Future<void> getClinics() async {
    try {
      // Tidak perlu logic ribet ambil gambar manual lagi,
      // cukup ambil list klinik dari API.
      final response = await http.get(Uri.parse('$baseUrl/clinics'));

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        clinics.value = data.map((item) => Clinic.fromJson(item)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch clinics: $e');
    }
  }

  // --- 3. ADD POLY ---
  Future<void> addPoly(Poly poly) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/polies');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(poly.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getPolies(); // Refresh list
        Get.snackbar('Success', 'Poly added successfully');
      } else {
        print("Error Add Poly: ${response.body}");
        Get.snackbar('Error', 'Failed to add poly: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Add: $e");
      Get.snackbar('Error', 'Failed to add poly: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. UPDATE POLY ---
  Future<void> updatePoly(Poly poly) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/polies/${poly.id}');

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(poly.toJson()),
      );

      if (response.statusCode == 200) {
        await getPolies(); // Refresh list
        Get.snackbar('Success', 'Poly updated successfully');
      } else {
        print("Error Update Poly: ${response.body}");
        Get.snackbar('Error', 'Failed to update poly: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Update: $e");
      Get.snackbar('Error', 'Failed to update poly: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 5. DELETE POLY ---
  Future<void> deletePoly(String id) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/polies/$id');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        await getPolies(); // Refresh list
        Get.snackbar('Success', 'Poly deleted successfully');
      } else {
        print("Error Delete Poly: ${response.body}");
        Get.snackbar('Error', 'Failed to delete poly: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Delete: $e");
      Get.snackbar('Error', 'Failed to delete poly: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
