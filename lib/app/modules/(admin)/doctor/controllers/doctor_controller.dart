import 'package:clinic_ai/model/doctorModel.dart';
import 'package:clinic_ai/model/clinicsModel.dart';
import 'package:clinic_ai/model/poliesModel.dart';
import 'package:clinic_ai/model/userModel.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Doctor> doctors = <Doctor>[].obs;
  RxList<Users> users = <Users>[].obs;
  RxList<Clinics> clinics = <Clinics>[].obs;
  RxList<Polies> polies = <Polies>[].obs;
  RxBool isLoading = false.obs;
  var selectedClinicId = ''.obs;
  var selectedPolyId = ''.obs;
  var selectedUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getDoctors();
    getClinics();
    getPolies();
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

  Future<void> getUsers() async {
    try {
      isLoading.value = true;
      final response =
          await supabase.from('users').select().order('name', ascending: true);

      users.value =
          response.map((item) => Users.fromJson(item)).toList().cast<Users>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch doctors: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDoctor(Doctor doctor) async {
    try {
      isLoading.value = true;
      await supabase.from('doctors').insert(doctor.toJson());
      await getDoctors(); // Refresh the list
      Get.snackbar('Success', 'Doctor added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add doctor: $e');
      print('Error Failed to add doctor: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      isLoading.value = true;
      await supabase
          .from('doctors')
          .update(doctor.toJson())
          .eq('id', doctor.id)
          .order('name', ascending: false);
      await getDoctors(); // Refresh the list
      Get.snackbar('Success', 'Doctor updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update doctor: $e');
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getClinics() async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('clinics')
          .select()
          .order('name', ascending: true);

      clinics.value = response
          .map((item) => Clinics.fromJson(item))
          .toList()
          .cast<Clinics>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch clinics: $e');
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
          response.map((item) => Polies.fromJson(item)).toList().cast<Polies>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch polies: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDoctor(String id) async {
    try {
      isLoading.value = true;
      await supabase.from('doctors').delete().eq('id', id);
      await getDoctors(); // Refresh the list
      Get.snackbar('Success', 'Doctor deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete doctor: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
