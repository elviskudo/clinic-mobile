import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PersonalDataController extends GetxController {
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

  RxString currentUserRole = 'member'.obs;

  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';

  @override
  void onInit() {
    super.onInit();
    _initRole();
    citySearchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (citySearchController.text.isEmpty) {
          showCityList.value = false;
          cities.clear();
        } else {
          final currentDisplay = [
            selectedVillage.value,
            selectedSubDistrict.value,
            selectedDistrict.value,
            selectedProvince.value
          ].where((e) => e.isNotEmpty).join(', ');

          if (citySearchController.text != currentDisplay) {
            searchCities(citySearchController.text);
          }
        }
      });
    });

    // FIX: Tunda pemanggilan API sedikit saja agar Flutter selesai build UI pertama kali.
    // Ini akan mencegah error "setState() called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserData();
    });
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> _initRole() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserRole.value = prefs.getString('userRole') ?? 'member';
  }

  // --- HELPER: CAPITALIZE FIRST LETTER ---
  String capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // ==========================================
  // 1. PENCARIAN KOTA (SEARCH CITIES)
  // ==========================================
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
      String searchTerm = searchTerms.first;

      // Menerapkan kapitalisasi sebagai lapisan pengamanan pertama
      searchTerm = capitalizeWords(searchTerm);

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/profile/cities/search?q=$searchTerm'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedBody = json.decode(response.body);

        // FIX: Ekstraksi Data JSON yang Super Aman & Kebal Error
        List<dynamic> rawList = [];
        if (decodedBody is List) {
          rawList = decodedBody;
        } else if (decodedBody is Map) {
          if (decodedBody['data'] is List) {
            rawList = decodedBody['data'];
          } else if (decodedBody['data'] != null) {
            // Jika backend anehnya mereturn object tunggal
            rawList = [decodedBody['data']];
          }
        }

        // Mapping ke List<Map<String, dynamic>> dengan aman
        cities.value = rawList
            .map((e) {
              if (e is Map) return Map<String, dynamic>.from(e);
              return <String, dynamic>{};
            })
            .where((e) => e.isNotEmpty)
            .toList();

        showCityList.value = cities.isNotEmpty;
      } else {
        throw Exception('Gagal memuat kota');
      }
    } catch (e) {
      print('Error searching cities: $e');
      // Matikan sementara snackbar error search agar tidak mengganggu UI jika ketikan terlalu cepat
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

    citySearchController.text = [
      city['village'],
      city['sub_district'],
      city['district'],
      city['province']
    ].where((element) => element != null && element.isNotEmpty).join(', ');

    cities.clear();
    showCityList.value = false;
  }

  // ==========================================
  // 2. AMBIL DATA PERSONAL (GET)
  // ==========================================
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$baseUrl/profile/personal-data'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final String body = response.body;

        if (body.isNotEmpty) {
          final decoded = json.decode(body);
          final userData = decoded['data'] ?? decoded;

          nameController.text = userData['name'] ?? '';
          placeOfBirthController.text = userData['place_of_birth'] ?? '';

          if (userData['date_of_birth'] != null) {
            final DateTime dob = DateTime.parse(userData['date_of_birth']);
            dateOfBirthController.text = formatDate(dob);
          } else {
            dateOfBirthController.text = '';
          }

          if (userData['gender'] != null) {
            if (userData['gender'] == 1) {
              selectedGender.value = 'Male';
            } else if (userData['gender'] == 2) {
              selectedGender.value = 'Female';
            } else {
              selectedGender.value = null;
            }
          }

          cardNumberController.text = userData['card_number'] ?? '';
          addressController.text = userData['address'] ?? '';
          rtController.text = (userData['rt'] ?? '').toString();
          rwController.text = (userData['rw'] ?? '').toString();
          selectedCityId.value = userData['city_id']?.toString() ?? '';
          postalCodeController.text =
              (userData['postal_code'] ?? '').toString();
          selectedResponsibleForCosts.value = userData['responsible_for_costs'];
          selectedBloodGroup.value = userData['blood_group'];

          final cityData = userData['cityData'];
          if (cityData != null) {
            selectedProvince.value = cityData['province'] ?? '';
            selectedDistrict.value = cityData['district'] ?? '';
            selectedSubDistrict.value = cityData['sub_district'] ?? '';
            selectedVillage.value = cityData['village'] ?? '';

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
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // 3. SIMPAN/UPDATE DATA PERSONAL (POST)
  // ==========================================
  Future<void> saveOrUpdateProfile(BuildContext context) async {
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
      final headers = await _getHeaders();

      int? genderValue;
      if (selectedGender.value == 'Male') {
        genderValue = 1;
      } else if (selectedGender.value == 'Female') {
        genderValue = 2;
      }

      final Map<String, dynamic> payload = {
        "name": nameController.text.isNotEmpty ? nameController.text : null,
        "place_of_birth": placeOfBirthController.text.isNotEmpty
            ? placeOfBirthController.text
            : null,
        "date_of_birth": dateOfBirthController.text.isNotEmpty
            ? dateOfBirthController.text
            : null,
        "gender": genderValue,
        "card_number": cardNumberController.text.isNotEmpty
            ? cardNumberController.text
            : null,
        "address":
            addressController.text.isNotEmpty ? addressController.text : null,
        "rt": rtController.text.isNotEmpty
            ? int.tryParse(rtController.text)
            : null,
        "rw": rwController.text.isNotEmpty
            ? int.tryParse(rwController.text)
            : null,
        "city_id": selectedCityId.value?.isNotEmpty == true
            ? selectedCityId.value
            : null,
        "postal_code": postalCodeController.text.isNotEmpty
            ? int.tryParse(postalCodeController.text)
            : null,
        "responsible_for_costs": selectedResponsibleForCosts.value,
        "blood_group": selectedBloodGroup.value,
      };

      payload.removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('$baseUrl/profile/personal-data'),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("userName", nameController.text);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Data updated successfully!',
          desc:
              'Yeay, your data has been successfully updated, let\'s continue!',
          btnOkOnPress: () {
            // FIX: Cek role untuk menentukan rute kembali saat data sukses disimpan
            if (currentUserRole.value == 'doctor') {
              Get.offAllNamed(Routes.HOME_DOCTOR);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          },
          btnOkText: 'OK',
          btnOkColor: Colors.green,
          width: MediaQuery.of(context).size.width,
          dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          dialogBorderRadius:
              const BorderRadius.vertical(top: Radius.circular(10)),
          alignment: Alignment.bottomCenter,
        ).show();
      } else {
        throw Exception('Server error: ${response.body}');
      }
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

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
