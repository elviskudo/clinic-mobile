import 'package:clinic_ai/app/modules/(home)/home/controllers/home_controller.dart';
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

    Future<void> handleImagePicker() async {
      final ImagePicker picker = ImagePicker();
      try {
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          controller.uploadController.selectedImage.value = image;
          await controller.updateProfileImage();
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to pick image: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
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
          // FIX: Tombol back dinamis berdasarkan role
          onPressed: () {
            if (controller.currentUserRole.value == 'doctor') {
              Get.offNamed(Routes
                  .HOME_DOCTOR); // Atau HOME_DOCTOR jika belum ada route PROFILE_DOCTOR
            } else {
              Get.offNamed(Routes.PROFILE);
            }
          },
          icon: Image.asset(
            'assets/icons/back.png',
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // FIX: Badge dinamis (Doctor atau Patients)
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xffD4E8D1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF516351),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    controller.currentUserRole.value == 'doctor'
                        ? 'Doctor'
                        : 'Patients',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF516351),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
            const Gap(24),
            Center(
              child: Column(
                children: [
                  Obx(() {
                    // FIX: Mengambil Image URL dari Controller yang aman
                    final String imageUrl = controller.currentImageUrl.value;
                    final bool hasImage = imageUrl.trim().isNotEmpty;

                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.lightGreen[100],
                          backgroundImage:
                              hasImage ? NetworkImage(imageUrl) : null,
                          child: !hasImage
                              ? const Icon(Icons.person_outline,
                                  color: Colors.black, size: 70)
                              : null,
                        ),
                        if (controller.isLoading.value)
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(24),
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
            const Gap(16),
            Container(
              height: 1,
              color: const Color(0xFFC1C9BE),
            ),
            const Gap(16),
            _buildMenuItem(
              iconPath: 'assets/icons/personaldata.png',
              title: 'Personal Data',
              subtitle: 'ID Number, Gender, Address',
              onTap: () {
                Get.toNamed(Routes.PERSONAL_DATA);
              },
            ),
            _buildMenuItem(
              iconPath: 'assets/icons/personaldata.png',
              title: 'Notifications',
              subtitle: 'Tickets Notification, Queue',
              onTap: () {},
            ),
            const Gap(24),
            ElevatedButton(
              onPressed: () {
                homeCtrl.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 54),
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
                  color: const Color(0xff35693E),
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
          color: const Color(0xff35693E),
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
          color: const Color(0xff727970),
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
