import 'package:clinic_ai/models/drug_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DrugAdminController extends GetxController {
  //TODO: Implement DrugAdminController
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Drug> drugs = <Drug>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDrugs();
  }

  Future<void> getDrugs() async {
    try {
      isLoading.value = true;
      final response =
          await supabase.from('drugs').select().order('name', ascending: true);

      drugs.value =
          response.map((item) => Drug.fromJson(item)).toList().cast<Drug>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch drugs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDrug(Drug drug) async {
    try {
      isLoading.value = true;
      await supabase.from('drugs').insert(drug.toJson());
      await getDrugs(); // Refresh the list
      Get.snackbar('Success', 'Drug added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add drug: $e');
      print('Error Failed to add drug: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDrug(Drug drug) async {
    try {
      isLoading.value = true;
      await supabase
          .from('drugs')
          .update(drug.toJson())
          .eq('id', drug.id)
          .order('name', ascending: false);
      await getDrugs(); // Refresh the list
      Get.snackbar('Success', 'Drug updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update drug: $e');
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDrug(String id) async {
    try {
      isLoading.value = true;
      await supabase.from('drugs').delete().eq('id', id);
      await getDrugs(); // Refresh the list
      Get.snackbar('Success', 'Drug deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete drug: $e');
    } finally {
      isLoading.value = false;
    }
  }
}