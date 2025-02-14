import 'package:clinic_ai/models/scheduleDate_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleTimeController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<ScheduleTime> scheduleTimes = <ScheduleTime>[].obs;
  RxList<ScheduleDate> scheduleDates = <ScheduleDate>[].obs;
  RxBool isLoading = false.obs;
  var selectedDateId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getScheduleTimes();
    getScheduleDates();
  }

  Future<void> getScheduleTimes() async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('schedule_times')
          .select()
          .order('schedule_time', ascending: true);

      scheduleTimes.value = response
          .map((item) => ScheduleTime.fromJson(item))
          .toList()
          .cast<ScheduleTime>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch schedule times: $e');
    } finally {
      isLoading.value = false;
    }
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

  Future<void> addScheduleTime(ScheduleTime scheduleTime) async {
    try {
      isLoading.value = true;
      await supabase.from('schedule_times').insert(scheduleTime.toJson());
      await getScheduleTimes(); // Refresh the list
      Get.snackbar('Success', 'Schedule time added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add schedule time: $e');
      print('Error Failed to add schedule time: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateScheduleTime(ScheduleTime scheduleTime) async {
    try {
      isLoading.value = true;
      await supabase
          .from('schedule_times')
          .update(scheduleTime.toJson())
          .eq('id', scheduleTime.id);
      await getScheduleTimes(); // Refresh the list
      Get.snackbar('Success', 'Schedule time updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update schedule time: $e');
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteScheduleTime(String id) async {
    try {
      isLoading.value = true;
      await supabase.from('schedule_times').delete().eq('id', id);
      await getScheduleTimes(); // Refresh the list
      Get.snackbar('Success', 'Schedule time deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete schedule time: $e');
    } finally {
      isLoading.value = false;
    }
  }
}