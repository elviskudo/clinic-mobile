import 'dart:io';

import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/helper/PasswordHasher.dart';
import 'package:clinic_ai/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart' as dio;

class ListUserController extends GetxController {
  final supabase = Supabase.instance.client;
  final RxList<Users> usersList = <Users>[].obs;
  RxBool isLoading = false.obs;
  RxString roleUser = ''.obs;
  RxString currentUserId = ''.obs;
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  RxString selectedRoleId = ''.obs;

  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final Rx<Users?> currentUser = Rx<Users?>(null);
  final cloudName = 'dcthljxbl';
  final uploadPreset = 'dompet-mal';

  @override
  void onInit() {
    super.onInit();
    getCurrentUser().then((_) => loadCurrentUserData());
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      await GoogleSignIn().signOut();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      // await prefs.clear(); // Clears all data
      // Or clear specific keys if you prefer:
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('email');
      await prefs.remove('name');
      await prefs.remove('phone');
      await prefs.remove('userId');
      // await prefs.remove('accessToken');

      Get.snackbar(
        'Sukses',
        'Berhasil logout',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to login page
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal logout: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId.value = prefs.getString('userId') ?? '';
  }

  Future<void> createUser() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final formattedPhoneNumber = formatPhoneNumber(phoneController.text);

      // Use selected role ID instead of fetching default role
      if (selectedRoleId.value.isEmpty) {
        throw 'Please select a role';
      }

      // Insert data ke table users
      final hashedPassword =
          await PasswordHasher.hashPassword(passwordController.text);
      String userId = Uuid().v4();
      final userData = {
        'id': userId,
        'name': namaController.text,
        'email': emailController.text.toLowerCase(),
        'password': hashedPassword,
        'phone_number': formattedPhoneNumber,
        'access_token': '',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('users').insert(userData);

      // Insert ke table user_roles dengan selected role
      final userRoleData = {
        'user_id': userId,
        'role_id': selectedRoleId.value,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabase.from('user_roles').insert(userRoleData);

      Get.snackbar(
        'Sukses',
        'User berhasil dibuat',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form
      namaController.clear();
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      selectedRoleId.value = ''; // Reset selected role

      // Refresh user list
      await fetchUsers();

      Get.back(); // Tutup dialog form
    } catch (error) {
      print('Error creating user: $error');
      String errorMessage = 'Terjadi kesalahan saat membuat user';

      if (error is PostgrestException) {
        if (error.code == '23505') {
          errorMessage = 'Email sudah terdaftar';
        }
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Tambahkan helper method untuk format nomor telepon
  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = cleanPhone.substring(1);
    }
    if (!cleanPhone.startsWith('62')) {
      cleanPhone = '62$cleanPhone';
    }
    return '+$cleanPhone';
  }

  Future<bool> isAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('userRole');

      if (role != 'admin') {
        // Navigate back to previous page or login
        Get.offAllNamed(Routes.LOGIN);
        return false;
      }

      return role == 'admin';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify admin role: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.LOGIN);
      return false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;

      await supabase.from('user_roles').delete().eq('user_id', userId);
      // Hapus pengguna dari tabel `users`
      await supabase.from('users').delete().eq('id', userId);

      await fetchUsers();

      // Hapus entri dari tabel `user_roles`

      Get.snackbar(
        'Success',
        'User successfully deleted',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Perbarui daftar pengguna
      update();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete user: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      isLoading.value = true;
      await supabase.from('users').update(updatedData).eq('id', userId);

      // Fetch updated users list
      await fetchUsers();

      Get.snackbar(
        'Success',
        'User successfully updated',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileWithImage({
    required String name,
    required String phone,
  }) async {
    try {
      isLoading.value = true;

      // 1. First update user data
      final formattedPhoneNumber = formatPhoneNumber(phone);
      final updatedData = {
        'name': name,
        'phone_number': formattedPhoneNumber,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await supabase
          .from('users')
          .update(updatedData)
          .eq('id', currentUserId.value);

      // 2. Handle image upload if selected
      if (selectedImage.value != null) {
        final bytes = await File(selectedImage.value!.path).readAsBytes();
        final fileName = selectedImage.value!.path.split('/').last;

        final formData = dio.FormData.fromMap({
          'file': dio.MultipartFile.fromBytes(
            bytes,
            filename: fileName,
          ),
          'upload_preset': uploadPreset,
        });

        final response = await dio.Dio().post(
          'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
          data: formData,
        );

        if (response.statusCode == 200) {
          // Get the URL from Cloudinary response
          String imageUrl = response.data['secure_url'];

          // Update or create file record
          final fileData = {
            'module_class': 'users',
            'module_id': currentUserId.value,
            'file_name': imageUrl,
            'file_type': 'image',
            'updated_at': DateTime.now().toIso8601String(),
          };

          // Check if file exists
          final existingFile = await supabase
              .from('files')
              .select()
              .eq('module_class', 'users')
              .eq('module_id', currentUserId.value)
              .maybeSingle();

          if (existingFile != null) {
            // Update existing file
            await supabase
                .from('files')
                .update(fileData)
                .eq('id', existingFile['id']);
          } else {
            // Insert new file
            fileData['created_at'] = DateTime.now().toIso8601String();
            await supabase.from('files').insert(fileData);
          }
        }
      }

      // 3. Refresh data
      await fetchUsers();
      await loadCurrentUserData();

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      selectedImage.value = null;
    }
  }

// Add this method to load current user data
  Future<void> loadCurrentUserData() async {
    try {
      final users = await fetchUsers();
      final currentUser = users.firstWhere(
        (user) => user.id == currentUserId.value,
        orElse: () => throw Exception('User not found'),
      );

      namaController.text = currentUser.name;
      emailController.text = currentUser.email;
      phoneController.text = currentUser.phoneNumber.replaceFirst('+62', '');

      this.currentUser.value = currentUser;
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> updateUserRole(String userId, String roleId) async {
    try {
      isLoading.value = true;

      // Perbarui role_id di tabel `user_roles`
      await supabase
          .from('user_roles')
          .update({'role_id': roleId}).eq('user_id', userId);

      // Fetch updated users list after role update
      await fetchUsers();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user role: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Users>> fetchUsers() async {
    try {
      final response = await supabase.from('users').select('*');
      final data = response as List<dynamic>;

      List<Users> users = [];

      for (final user in data) {
        final userRole = await supabase
            .from('user_roles')
            .select()
            .eq('user_id', user['id'])
            .single();

        final roles = await supabase
            .from('roles')
            .select()
            .eq('id', userRole['role_id'])
            .single();

        final roleName = roles['name'] ?? 'member';

        // Fetch user image from files
        String? imageUrl;
        final fileResponse = await supabase
            .from('files')
            .select('file_name')
            .eq('module_class', 'users')
            .eq('module_id', user['id'])
            .maybeSingle();

        if (fileResponse != null) {
          imageUrl = fileResponse['file_name'];
        }

        users.add(Users(
          id: user['id'] as String,
          name: user['name'] as String,
          email: user['email'] as String,
          role: roleName,
          phoneNumber: user['phone_number'] as String,
          accessToken: user['access_token'] as String,
          imageUrl: imageUrl, // Added image URL
          createdAt: DateTime.parse(user['created_at'] as String),
          updatedAt: DateTime.parse(user['updated_at'] as String),
        ));
      }

      // Update the reactive list
      usersList.value = users;
      return users;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch users: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchRoles() async {
    try {
      // Ambil semua role dari tabel `roles`
      final response = await supabase.from('roles').select('*');

      // Mapping hasil data ke List<Map<String, String>>
      return (response as List<dynamic>)
          .map((role) => {
                'id': role['id'] as String,
                'name': role['name'] as String,
              })
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch roles: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    }
  }

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
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void showEditDialog(BuildContext context, Users user) async {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    String selectedRoleId = ''; // Role yang dipilih
    List<Map<String, String>> roles = []; // Daftar role

    // Ambil daftar role dari controller
    roles = await fetchRoles();
    selectedRoleId =
        roles.firstWhere((role) => role['name'] == user.role)['id'] ?? '';

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
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRoleId,
                      items: roles
                          .map((role) => DropdownMenuItem(
                                value: role['id'],
                                child: Text(role['name']!),
                              ))
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
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final updatedData = {
                      'name': nameController.text,
                      'email': emailController.text,
                    };

                    // Perbarui data pengguna
                    await updateUser(user.id, updatedData);

                    // Perbarui role pengguna jika ada perubahan
                    if (selectedRoleId.isNotEmpty &&
                        selectedRoleId !=
                            roles.firstWhere(
                                (role) => role['name'] == user.role)['id']) {
                      await updateUserRole(user.id, selectedRoleId);
                    }
// Fetch the updated list one final time to ensure everything is in sync
                    await fetchUsers();
                    // Navigator.pop(context); // Tutup dialog
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
  void onReady() {
    super.onReady();
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
