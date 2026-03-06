import 'dart:convert';
import 'dart:io';

import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; // Ganti Supabase dengan HTTP
import 'package:dio/dio.dart' as dio; // Khusus Cloudinary

class ListUserController extends GetxController {
  // URL Backend Vercel
  final String baseUrl = "https://be-clinic-rx7y.vercel.app";

  final RxList<Users> usersList = <Users>[].obs;
  RxBool isLoading = false.obs;
  RxString currentUserId = ''.obs;

  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  RxString selectedRoleId = ''.obs;

  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final Rx<Users?> currentUser = Rx<Users?>(null);

  // Config Cloudinary
  final cloudName = 'dcthljxbl';
  final uploadPreset = 'dompet-mal';

  @override
  void onInit() {
    super.onInit();
    getCurrentUser().then((_) {
      fetchUsers();
      loadCurrentUserData();
    });
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

  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith('0')) cleanPhone = cleanPhone.substring(1);
    if (!cleanPhone.startsWith('62')) cleanPhone = '62$cleanPhone';
    return '+$cleanPhone';
  }

  // --- 1. FETCH USERS (API) ---
  Future<List<Users>> fetchUsers() async {
    try {
      final url = Uri.parse('$baseUrl/users');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        final List<Users> loadedUsers = data.map((jsonItem) {
          // Sanitasi null values agar tidak crash
          if (jsonItem is Map<String, dynamic>) {
            jsonItem['role'] ??= 'member';
            jsonItem['phone_number'] ??= '';
            jsonItem['access_token'] ??= '';
          }
          return Users.fromJson(jsonItem);
        }).toList();

        usersList.value = loadedUsers;
        return loadedUsers;
      } else {
        print("Error Fetch Users: ${response.body}");
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e');
      return [];
    }
  }

  // --- 2. FETCH ROLES (API) ---
  Future<List<Map<String, String>>> fetchRoles() async {
    try {
      final url = Uri.parse('$baseUrl/roles');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);
        final List<dynamic> data = _parseListResponse(decodedBody);

        return data
            .map<Map<String, String>>((role) => {
                  'id': role['id'].toString(),
                  'name': role['name'].toString(),
                })
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching roles: $e');
      return [];
    }
  }

  // --- 3. CREATE USER (API) ---
  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedRoleId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a role',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final formattedPhoneNumber = formatPhoneNumber(phoneController.text);

      // Payload sesuai DTO Backend
      final userData = {
        'name': namaController.text,
        'email': emailController.text.toLowerCase(),
        'password': passwordController
            .text, // Kirim password MENTAH, Backend yang hash!
        'phone_number': formattedPhoneNumber,
        'role_id': selectedRoleId.value,
      };

      final url = Uri.parse('$baseUrl/users');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Sukses', 'User berhasil dibuat',
            backgroundColor: Colors.green, colorText: Colors.white);

        // Reset Form
        namaController.clear();
        emailController.clear();
        passwordController.clear();
        phoneController.clear();
        selectedRoleId.value = '';

        await fetchUsers();
        Get.back();
      } else {
        String msg = 'Gagal membuat user';
        try {
          final body = json.decode(response.body);
          msg = body['message'] ?? msg;
        } catch (_) {}
        Get.snackbar('Error', msg,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. UPDATE USER (API) ---
  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/users/$userId');

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        await fetchUsers();
        Get.snackbar('Success', 'User successfully updated',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed to update: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Update failed: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 5. DELETE USER (API) ---
  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/users/$userId');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        await fetchUsers();
        Get.snackbar('Success', 'User deleted',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Failed delete: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Delete failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 6. UPDATE PROFILE WITH IMAGE (API) ---
  Future<void> updateProfileWithImage(
      {required String name, required String phone}) async {
    try {
      isLoading.value = true;
      String formattedPhone = formatPhoneNumber(phone);
      String? uploadedImageUrl;

      // A. Upload ke Cloudinary
      if (selectedImage.value != null) {
        final bytes = await File(selectedImage.value!.path).readAsBytes();
        final fileName = selectedImage.value!.path.split('/').last;
        final formData = dio.FormData.fromMap({
          'file': dio.MultipartFile.fromBytes(bytes, filename: fileName),
          'upload_preset': uploadPreset,
        });

        final uploadRes = await dio.Dio().post(
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
          data: formData,
        );

        if (uploadRes.statusCode == 200) {
          uploadedImageUrl = uploadRes.data['secure_url'];
        }
      }

      // B. Update Data ke Backend
      final updatePayload = {
        'name': name,
        'phone_number': formattedPhone,
        if (uploadedImageUrl != null) 'image_url': uploadedImageUrl,
      };

      final url = Uri.parse('$baseUrl/users/${currentUserId.value}');
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatePayload),
      );

      if (response.statusCode == 200) {
        await fetchUsers();
        await loadCurrentUserData();
        Get.snackbar('Success', 'Profile updated',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print('Backend Error: ${response.body}');
        Get.snackbar('Error', 'Failed to update profile backend');
      }
    } catch (e) {
      print('Error update profile: $e');
      Get.snackbar('Error', '$e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
      selectedImage.value = null;
    }
  }

  // --- 7. UPDATE USER ROLE (API) ---
  Future<void> updateUserRole(String userId, String roleId) async {
    try {
      isLoading.value = true;
      // Gunakan endpoint update user biasa, kirim role_id
      final url = Uri.parse('$baseUrl/users/$userId');

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'role_id': roleId}),
      );

      if (response.statusCode == 200) {
        await fetchUsers();
      } else {
        print("Gagal update role: ${response.body}");
        Get.snackbar('Error', 'Failed to update role');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed update role: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- UTILS ---
  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
  }

  Future<void> loadCurrentUserData() async {
    try {
      if (usersList.isEmpty) await fetchUsers();

      final user = usersList.firstWhere(
        (u) => u.id == currentUserId.value,
        orElse: () => Users(
            id: '',
            name: '',
            email: '',
            role: '',
            phoneNumber: '',
            accessToken: '',
            createdAt: DateTime.now()),
      );

      if (user.id.isNotEmpty) {
        namaController.text = user.name;
        emailController.text = user.email;
        phoneController.text = user.phoneNumber.replaceFirst('+62', '');
        currentUser.value = user;
      }
    } catch (e) {
      print("Load current user error: $e");
    }
  }

  Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('userRole');
    if (role != 'admin') {
      Get.offAllNamed(Routes.LOGIN);
      return false;
    }
    return true;
  }

  // --- UI HELPER: LOGOUT ---
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await GoogleSignIn().signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Hapus semua sesi
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Logout failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- UI HELPER: DIALOGS ---
  Future<bool> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete User'),
              content: Text('Are you sure you want to delete this user?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Delete')),
              ],
            );
          },
        ) ??
        false;
  }

  void showEditDialog(BuildContext context, Users user) async {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    String selectedRoleId = '';

    // Fetch roles untuk dropdown
    List<Map<String, String>> roles = await fetchRoles();

    try {
      // Match nama role user dengan ID role dari database
      final foundRole =
          roles.firstWhere((r) => r['name'] == user.role, orElse: () => {});
      if (foundRole.isNotEmpty) selectedRoleId = foundRole['id']!;
    } catch (e) {
      print("Role match error: $e");
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name')),
                    TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email')),
                    if (roles.isNotEmpty)
                      DropdownButtonFormField<String>(
                        value:
                            selectedRoleId.isNotEmpty ? selectedRoleId : null,
                        items: roles
                            .map((role) => DropdownMenuItem(
                                value: role['id'], child: Text(role['name']!)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRoleId = value!;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Role'),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                TextButton(
                  onPressed: () async {
                    final updatedData = {
                      'name': nameController.text,
                      'email': emailController.text
                    };

                    // 1. Update info user
                    await updateUser(user.id, updatedData);

                    // 2. Update role jika dipilih
                    if (selectedRoleId.isNotEmpty) {
                      await updateUserRole(user.id, selectedRoleId);
                    }

                    await fetchUsers();
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
