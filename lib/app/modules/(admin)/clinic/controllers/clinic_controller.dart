import 'package:clinic_ai/model/clinicsModel.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClinicController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  RxList<Clinics> clinics = <Clinics>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dgetClinics();
  }

  // Get all categories
  Future<void> dgetClinics() async {
    try {
      isLoading.value = true;
      final response = await supabase
          .from('clinics')
          .select()
          .order('name', ascending: true);

      List<Clinics> clinicsWithImages = [];
      for (var item in response) {
        final clinics = Clinics.fromJson(item);

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

  // Add new category
  Future<void> addClinics(Clinics clinics) async {
    try {
      isLoading.value = true;
      await supabase.from('clinics').insert(clinics.toJson());
      await dgetClinics(); // Refresh the list
      Get.snackbar('Success', 'clinics added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add clinics: $e');
      print('Error Failed to add clinics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update category
  Future<void> updateClinics(Clinics clinics) async {
    try {
      isLoading.value = true;
      await supabase
          .from('clinics')
          .update(clinics.toJson())
          .eq('id', clinics.id as Object)
          .order(
            'name',
            ascending: false,
          );
      await dgetClinics(); // Refresh the list
      Get.snackbar('Success', 'clinics updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
      print('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete category
  Future<void> deleteClinics(String id) async {
    try {
      isLoading.value = true;
      await supabase.from('clinics').delete().eq('id', id);
      await dgetClinics(); // Refresh the list
      Get.snackbar('Success', 'clinics deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
