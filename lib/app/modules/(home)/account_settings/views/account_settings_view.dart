import 'package:clinic_ai/app/modules/(home)/home/controllers/home_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/account_settings_controller.dart';

class AccountSettingsView extends GetView<AccountSettingsController> {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.put(HomeController());
    return Scaffold(
      backgroundColor: Color(0xffF7FBF2),
      appBar: AppBar(
        backgroundColor: Color(0xffF7FBF2),
        title: Text(
          'Account Settings',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.PROFILE),
          icon: Image.asset('assets/icons/back.png'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Small Card above Profile
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xffD4E8D1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF516351), // Warna border
                  width: 2, // Ketebalan border
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

            // Profile Photo Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffD4E8D1),
                      border: Border.all(color: Color(0xFF516351), width: 2),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 50,
                      color: Colors.black54,
                    ),
                  ),
                  Gap(24),
                  TextButton(
                    onPressed: () {
                      // Handle change profile photo
                    },
                    child: Text(
                      'Change Profile Photo',
                      style: GoogleFonts.inter(
                        color: Color(0xff35693E),
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

            // Menu Items
            _buildMenuItem(
              iconPath: 'assets/icons/personaldata.png',
              title: 'Personal Data',
              subtitle: 'ID Number, Gender, Diagnosis',
              onTap: () {
                Get.offAllNamed(Routes.PERSONAL_DATA);
              },
            ),
            _buildMenuItem(
              iconPath: 'assets/icons/key.png',
              title: 'Accounts',
              subtitle: 'Change Email, Change Password',
              onTap: () {
                // Handle accounts tap
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
            // Logout Button
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
                    color: Color(0xff35693E)),
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
        color: Colors.black54,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
