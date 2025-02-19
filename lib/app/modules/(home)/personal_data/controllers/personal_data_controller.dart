import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class PersonalDataController extends GetxController {
  final supabase = Supabase.instance.client;

  final nameController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final cardNumberController = TextEditingController();
  final addressController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();
  final postalCodeController = TextEditingController();
  final citySearchController = TextEditingController();

  final selectedGender = Rx<String?>(null);
  final selectedCityId = Rx<String?>(null);
  final selectedResponsibleForCosts = Rx<String?>(null);
  final selectedBloodGroup = Rx<String?>(null);

  final cities = <Map<String, dynamic>>[].obs;
  final isLoadingCities = false.obs;
  final citySearchQuery = ''.obs;
  final selectedCityName = Rx<String>('');
  final selectedProvince = Rx<String>('');
  final selectedDistrict = Rx<String>('');
  final selectedSubDistrict = Rx<String>('');
  final selectedVillage = Rx<String>('');
  final showCityList = false.obs;
  final isLoading = false.obs;
  Timer? _debounce;
  @override
  void onInit() {
    super.onInit();
    citySearchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (citySearchController.text.isEmpty) {
          showCityList.value = false;
          cities.clear();
        } else {
          searchCities(citySearchController.text);
        }
      });
    });
    loadUserData();
  }

  Future<void> searchCities(String query) async {
    try {
      if (query.isEmpty) {
        cities.clear();
        showCityList.value = false;
        return;
      }

      isLoadingCities.value = true;
      citySearchQuery.value = query;

      final searchTerms = query
          .split(',')
          .map((term) => term.trim())
          .where((term) => term.isNotEmpty)
          .toList();

      final searchTerm = searchTerms.first;

      final response = await supabase
          .from('cities')
          .select('id, province, district, sub_district, village')
          .or('village.ilike.%${searchTerm}%,sub_district.ilike.%${searchTerm}%,district.ilike.%${searchTerm}%')
          .limit(20);

      cities.value = List<Map<String, dynamic>>.from(response);
      showCityList.value = true;
    } catch (e) {
      print('Error searching cities: $e');
      Get.snackbar(
        "Terjadi Kesalahan",
        "Gagal mencari data kota: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoadingCities.value = false;
    }
  }

  void selectCity(Map<String, dynamic> city) {
    selectedCityId.value = city['id'].toString();
    selectedProvince.value = city['province'] ?? '';
    selectedDistrict.value = city['district'] ?? '';
    selectedSubDistrict.value = city['sub_district'] ?? '';
    selectedVillage.value = city['village'] ?? '';

    // Format the display text
    citySearchController.text = [
      city['village'],
      city['sub_district'],
      city['district'],
      city['province']
    ].where((element) => element != null && element.isNotEmpty).join(', ');

    cities.clear();

    showCityList.value = false;
  }

  Future<void> createProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print('userId: $userId');
    if (userId == null) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak ada sesi pengguna yang valid. Silahkan login kembali.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (nameController.text.isEmpty ||
        placeOfBirthController.text.isEmpty ||
        dateOfBirthController.text.isEmpty) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Nama, Tempat Lahir, dan Tanggal Lahir wajib diisi",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Handle gender as smallint
      int? genderValue;
      if (selectedGender.value == 'Male') {
        genderValue = 1; // Example: Male = 1
      } else if (selectedGender.value == 'Female') {
        genderValue = 2; // Example: Female = 2
      } else {
        genderValue = null; // Or handle for other cases as needed
      }

      final Map<String, dynamic> insertData = {
        "user_id": userId,
        "name": nameController.text,
        "place_of_birth": placeOfBirthController.text,
        "date_of_birth": dateOfBirthController.text,
        "gender": genderValue,
        "card_number": cardNumberController.text,
        "address": addressController.text,
        "rt": rtController.text,
        "rw": rwController.text,
        "city_id": selectedCityId.value,
        "postal_code": postalCodeController.text,
        "responsible_for_costs": selectedResponsibleForCosts.value,
        "blood_group": selectedBloodGroup.value,
        "updated_at": DateTime.now().toIso8601String(),
      };

      insertData.removeWhere(
          (key, value) => value == null || value.toString().isEmpty);

      await supabase.from("profiles").insert(insertData);

      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userName", nameController.text);
      await prefs.setString("user_id", userId);

      Get.snackbar(
        "Sukses",
        "Data pribadi berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak dapat memperbarui profil: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Tidak ada sesi pengguna yang valid. Silahkan login kembali.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // First, get the profile data
      final userData = await supabase
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .single();
      print('userData: $userData');
      if (userData == null) {
        Get.snackbar("User not found", "No profile data found for this user.");
        return;
      }

      if (userData != null) {
        // Fill in the profile data
        nameController.text = userData['name'] ?? '';
        placeOfBirthController.text = userData['place_of_birth'] ?? '';
        dateOfBirthController.text = userData['date_of_birth'] ?? '';

        // Map the gender from int to String
        if (userData['gender'] != null) {
          if (userData['gender'] == 1) {
            selectedGender.value = 'Male';
          } else if (userData['gender'] == 2) {
            selectedGender.value = 'Female';
          } else {
            selectedGender.value = null; // Or handle other cases
          }
        }

        cardNumberController.text = userData['card_number'] ?? '';
        addressController.text = userData['address'] ?? '';
        rtController.text = (userData['rt'] ?? '').toString();
        rwController.text = (userData['rw'] ?? '').toString();
        selectedCityId.value = userData['city_id']?.toString() ?? '';
        postalCodeController.text = (userData['postal_code'] ?? '').toString();
        selectedResponsibleForCosts.value = userData['responsible_for_costs'];
        selectedBloodGroup.value = userData['blood_group'];

        // If there's a city_id, fetch the city data separately
        if (userData['city_id'] != null) {
          final cityData = await supabase
              .from('cities')
              .select('id, province, district, sub_district, village')
              .eq('id', userData['city_id'])
              .single();

          if (cityData != null) {
            selectedProvince.value = cityData['province'] ?? '';
            selectedDistrict.value = cityData['district'] ?? '';
            selectedSubDistrict.value = cityData['sub_district'] ?? '';
            selectedVillage.value = cityData['village'] ?? '';

            // Display full location
            citySearchController.text = [
              cityData['village'],
              cityData['sub_district'],
              cityData['district'],
              cityData['province']
            ]
                .where((element) => element != null && element.isNotEmpty)
                .join(', ');
          }
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      Get.snackbar(
        "Terjadi Kesalahan",
        "Gagal memuat data profil: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak ada sesi pengguna yang valid. Silahkan login kembali.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (nameController.text.isEmpty ||
        placeOfBirthController.text.isEmpty ||
        dateOfBirthController.text.isEmpty) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Nama, Tempat Lahir, dan Tanggal Lahir wajib diisi",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Handle gender as smallint
      int? genderValue;
      if (selectedGender.value == 'Male') {
        genderValue = 1; // Example: Male = 1
      } else if (selectedGender.value == 'Female') {
        genderValue = 2; // Example: Female = 2
      } else {
        genderValue = null; // Or handle for other cases as needed
      }

      final Map<String, dynamic> updateData = {
        "name": nameController.text,
        "place_of_birth": placeOfBirthController.text,
        "date_of_birth": dateOfBirthController.text,
        "gender": genderValue,
        "card_number": cardNumberController.text,
        "address": addressController.text,
        "rt": rtController.text,
        "rw": rwController.text,
        "city_id": selectedCityId.value,
        "postal_code": postalCodeController.text,
        "responsible_for_costs": selectedResponsibleForCosts.value,
        "blood_group": selectedBloodGroup.value,
        "updated_at": DateTime.now().toIso8601String(),
      };

      updateData.removeWhere(
          (key, value) => value == null || value.toString().isEmpty);

      await supabase.from("profiles").update(updateData).eq('user_id', userId);

      // Update SharedPreferences
      await prefs.setString("userName", nameController.text);

      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Data updated successfully!',
        desc: 'Yeay, your data has been successfully updated, let\'s continue!',
        btnOkOnPress: () {
          Get.offAllNamed(Routes.HOME);
        },
        btnOkText: 'OK',
        btnOkColor: Colors.green,
        width: MediaQuery.of(context).size.width,
        dialogBackgroundColor: Colors.white,
        dialogBorderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        alignment: Alignment.bottomCenter, // Membuat dialog berada di bawah
      ).show();
    } catch (e) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak dapat memperbarui profil: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveOrUpdateProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      Get.snackbar(
        "Terjadi Kesalahan",
        "Tidak ada sesi pengguna yang valid. Silahkan login kembali.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check if the user already has a profile
    final userData = await supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (userData == null) {
      // User doesn't have a profile, create a new one
      await createProfile(context);
    } else {
      // User has a profile, update it
      await updateProfile(context);
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    _debounce?.cancel();
    citySearchController.dispose();
    nameController.dispose();
    placeOfBirthController.dispose();
    dateOfBirthController.dispose();
    cardNumberController.dispose();
    addressController.dispose();
    rtController.dispose();
    rwController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }
}
