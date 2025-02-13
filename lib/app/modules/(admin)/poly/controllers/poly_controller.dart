// import 'package:clinic_ai/model/clinicsModel.dart';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PolyController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Poly> polies = <Poly>[].obs;
  RxBool isLoading = false.obs;
  RxList<Clinic> clinics = <Clinic>[].obs;
   var selectedClinicId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPolies();
    getClinics();
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

  Future<void> addPoly(Poly poly) async {
    try {
      isLoading.value = true;
      await supabase.from('polies').insert(poly.toJson());
      await getPolies(); // Refresh the list
      Get.snackbar('Success', 'Poly added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add poly: $e');
      print('Error Failed to add poly: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePoly(Poly poly) async {
    try {
      isLoading.value = true;
      await supabase
          .from('polies')
          .update(poly.toJson())
          .eq('id', poly.id)
          .order('name', ascending: false);
      await getPolies(); // Refresh the list
      Get.snackbar('Success', 'Poly updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update poly: $e');
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

      List<Clinic> clinicsWithImages = [];
      for (var item in response) {
        final clinics = Clinic.fromJson(item);

        final fileResponse = await supabase
            .from('files')
            .select('file_name')
            .eq('module_class', 'clinics')
            .eq('module_id', clinics.id!)
            .limit(1)
            .maybeSingle();

        if (fileResponse != null) {
          clinics.imageUrl = fileResponse['file_name'];
        }

        clinicsWithImages.add(clinics);
      }

      clinics.value = clinicsWithImages;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch clinics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePoly(String id) async {
    try {
      isLoading.value = true;
      await supabase.from('polies').delete().eq('id', id);
      await getPolies(); // Refresh the list
      Get.snackbar('Success', 'Poly deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete poly: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
