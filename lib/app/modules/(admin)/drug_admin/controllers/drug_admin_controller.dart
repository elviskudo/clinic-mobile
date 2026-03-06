import 'dart:convert';
import 'package:clinic_ai/models/drug_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DrugAdminController extends GetxController {
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  RxList<Drug> drugs = <Drug>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDrugs();
  }

  // Helper Parsing
  List<dynamic> _parseListResponse(dynamic decodedBody) {
    if (decodedBody is List) return decodedBody;
    if (decodedBody is Map<String, dynamic>) {
      if (decodedBody['data'] is List) return decodedBody['data'];
      if (decodedBody['result'] is List) return decodedBody['result'];
    }
    return [];
  }

  // --- GET DRUGS ---
  Future<void> getDrugs() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('$baseUrl/drugs'));

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        drugs.value = data.map((item) => Drug.fromJson(item)).toList();
      } else {
        print("Error Get Drugs: ${response.body}");
      }
    } catch (e) {
      print("Exception Get Drugs: $e");
      Get.snackbar('Error', 'Failed to fetch drugs');
    } finally {
      isLoading.value = false;
    }
  }

  // --- ADD DRUG ---
  Future<void> addDrug(Drug drug) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/drugs');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(drug.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getDrugs();
        Get.snackbar('Success', 'Drug added successfully');
      } else {
        print("Error Add: ${response.body}");
        Get.snackbar('Error', 'Failed to add drug: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Add: $e");
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- UPDATE DRUG ---
  Future<void> updateDrug(Drug drug) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/drugs/${drug.id}');

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(drug.toJson()),
      );

      if (response.statusCode == 200) {
        await getDrugs();
        Get.snackbar('Success', 'Drug updated successfully');
      } else {
        print("Error Update: ${response.body}");
        Get.snackbar('Error', 'Failed to update drug: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Update: $e");
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- DELETE DRUG ---
  Future<void> deleteDrug(String id) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/drugs/$id');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        await getDrugs();
        Get.snackbar('Success', 'Drug deleted successfully');
      } else {
        print("Error Delete: ${response.body}");
        Get.snackbar('Error', 'Failed to delete drug: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception Delete: $e");
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}