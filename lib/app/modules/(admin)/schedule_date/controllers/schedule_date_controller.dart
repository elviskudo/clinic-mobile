import 'dart:convert';
import 'package:clinic_ai/app/modules/(admin)/schedule_time/controllers/schedule_time_controller.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ScheduleDateController extends GetxController {
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  RxList<ScheduleDate> scheduleDates = <ScheduleDate>[].obs;
  RxList<Doctor> doctors = <Doctor>[].obs;
  RxList<Poly> polies = <Poly>[].obs;

  RxBool isLoading = false.obs;

  var selectedPolyId = ''.obs;
  var selectedDoctorId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  // --- UPDATE: Load data secara paralel agar lebih cepat & rapi ---
  void loadAllData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        getDoctors(),
        getPolies(),
        getScheduleDates(),
        // Kita juga perlu refresh data Time agar sinkron
        Get.find<ScheduleTimeController>().getScheduleTimes() 
      ]);
    } catch (e) {
       print("Load Data Error: $e");
    } finally {
      isLoading.value = false;
    }
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

  Future<void> getScheduleDates() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/schedule-dates'));
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);
        scheduleDates.value =
            data.map((item) => ScheduleDate.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error Get ScheduleDates: $e");
    }
  }

  // --- PERBAIKAN UTAMA DI SINI ---
  Future<void> getDoctors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/doctors'));
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        doctors.value = data.map((item) {
          // SANITASI DATA: Pastikan semua field String ada isinya agar tidak error
          if (item is Map<String, dynamic>) {
            item['name'] ??= 'Unknown';
            item['degree'] ??= '';
            item['specialize'] ??= '';
            item['description'] ??= ''; // Sering error di sini jika null
            item['clinic_id'] ??= '';
            item['poly_id'] ??= '';
          }
          return Doctor.fromJson(item);
        }).toList();

        print("Doctors Loaded: ${doctors.length}"); // Debugging
      }
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }

  Future<void> getPolies() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/polies'));
      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        polies.value = data.map((item) {
          if (item is Map<String, dynamic>) {
            item['name'] ??= 'Unknown Poly';
            item['description'] ??= '';
          }
          return Poly.fromJson(item);
        }).toList();
      }
    } catch (e) {
      print("Error fetching polies: $e");
    }
  }

  // --- CRUD (Add, Update, Delete) tetap sama ---
  Future<void> addScheduleDate(ScheduleDate scheduleDate) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('$baseUrl/schedule-dates'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(scheduleDate.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201)  {
         loadAllData(); 
        Get.snackbar('Success', 'Schedule date created. Now add times.');
      } else {
        Get.snackbar('Error', 'Failed to add: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> updateScheduleDate(ScheduleDate scheduleDate) async {
    try {
      isLoading.value = true;
      final response = await http.patch(
        Uri.parse('$baseUrl/schedule-dates/${scheduleDate.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(scheduleDate.toJson()),
      );

      if (response.statusCode == 200) {
        loadAllData();
        Get.snackbar('Success', 'Updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteScheduleDate(String id) async {
    try {
      isLoading.value = true;
      final response =
          await http.delete(Uri.parse('$baseUrl/schedule-dates/$id'));

      if (response.statusCode == 200) {
        loadAllData(); // Refresh semua data setelah delete
        Get.snackbar('Success', 'Deleted successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
