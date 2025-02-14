import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleDateController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<ScheduleDate> scheduleDates = <ScheduleDate>[].obs;
  RxList<Doctor> doctors = <Doctor>[].obs;
  RxList<Poly> polies = <Poly>[].obs;
  RxBool isLoading = false.obs;
  var selectedPolyId = ''.obs;
  var selectedDoctorId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getScheduleDates();
    getDoctors();
    getPolies();
  }

  Future<void> getScheduleDates() async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('schedule_dates')
          .select()
          .order('schedule_date', ascending: true);

      scheduleDates.value = response
          .map((item) => ScheduleDate.fromJson(item))
          .toList()
          .cast<ScheduleDate>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch schedule dates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDoctors() async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('doctors')
          .select()
          .order('name', ascending: true);

      doctors.value =
          response.map((item) => Doctor.fromJson(item)).toList().cast<Doctor>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch doctors: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPolies() async {
    try {
      isLoading.value = true;
      final response =
          await supabase.from('polies').select().order('name', ascending: true);

      polies.value =
          response.map((item) => Poly.fromJson(item)).toList().cast<Poly>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch polies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addScheduleDate(ScheduleDate scheduleDate) async {
    try {
      isLoading.value = true;
      await supabase.from('schedule_dates').insert(scheduleDate.toJson());
      await getScheduleDates(); // Refresh the list
      Get.snackbar('Success', 'Schedule date added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add schedule date: $e');
      print('Error Failed to add schedule date: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateScheduleDate(ScheduleDate scheduleDate) async {
    try {
      isLoading.value = true;
      await supabase
          .from('schedule_dates')
          .update(scheduleDate.toJson())
          .eq('id', scheduleDate.id);
      await getScheduleDates(); // Refresh the list
      Get.snackbar('Success', 'Schedule date updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update schedule date: $e');
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteScheduleDate(String id) async {
    try {
      isLoading.value = true;
      await supabase.from('schedule_dates').delete().eq('id', id);
      await getScheduleDates(); // Refresh the list
      Get.snackbar('Success', 'Schedule date deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete schedule date: $e');
    } finally {
      isLoading.value = false;
    }
  }
}