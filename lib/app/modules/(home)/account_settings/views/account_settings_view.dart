import 'package:clinic_ai/app/modules/(home)/home/controllers/home_controller.dart';
import 'package:clinic_ai/app/modules/(home)/profile/controllers/profile_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/account_settings_controller.dart';

class AccountSettingsView extends GetView<AccountSettingsController> {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.put(HomeController());
    final profileCtrl = Get.put(ProfileController());

    Future<void> handleImagePicker() async {
      final ImagePicker picker = ImagePicker();
      try {
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          profileCtrl.uploadController.selectedImage.value = image;
          profileCtrl.isLoading.value = true; // Set loading to true

          await controller.updateProfileImage();
          await profileCtrl.loadUserData();

          profileCtrl.isLoading.value = false; // Set loading to false
        }
      } catch (e) {
        profileCtrl.isLoading.value = false; // Set loading to false on error
        Get.snackbar(
          'Error',
          'Failed to pick image: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Account Settings',
          style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color),
        ),
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.PROFILE),
          icon: Image.asset(
            'assets/icons/back.png',
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xffD4E8D1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF516351),
                  width: 2,
                ),
              ),
              child: Text(
                'Patients',
                style: GoogleFonts.inter(
                  color: const Color(0xFF516351),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Gap(24),
            Center(
              child: Column(
                children: [
                  Obx(() => Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: profileCtrl.user.value.imageUrl !=
                                    ''
                                ? NetworkImage(profileCtrl.user.value.imageUrl!)
                                : null,
                            backgroundColor: Colors.lightGreen[100],
                            child: profileCtrl.user.value.imageUrl == ''
                                ? Icon(Icons.person_outline,
                                    color: Colors.black, size: 70)
                                : null,
                          ),
                          if (profileCtrl.isLoading.value)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )),
                  Gap(24),
                  TextButton(
                    onPressed: () => handleImagePicker(),
                    child: Text(
                      'Change Profile Photo',
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(16),
            Container(
              height: 1,
              color: Color(0xFFC1C9BE),
            ),
            Gap(16),
            _buildMenuItem(
              iconPath: 'assets/icons/personaldata.png',
              title: 'Personal Data',
              subtitle: 'ID Number, Gender, Diagnosis',
              onTap: () {
                Get.offAllNamed(Routes.PERSONAL_DATA);
              },
            ),
            _buildMenuItem(
              iconPath: 'assets/icons/personaldata.png',
              title: 'Notifications',
              subtitle: 'Tickets Notification, Queue',
              onTap: () {
                // Handle notifications tap
              },
            ),
            Gap(24),
            ElevatedButton(
              onPressed: () {
                homeCtrl.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: Color(0xffC1C9BE), width: 1),
                ),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff35693E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          iconPath,
          color: Color(0xff35693E),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xff727970),
        ),
      ),
      trailing: Image.asset(
        'assets/icons/next.png',
        width: 24,
        height: 24,
        color: Theme.of(Get.context!).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
