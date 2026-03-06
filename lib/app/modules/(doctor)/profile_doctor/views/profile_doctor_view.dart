import 'package:clinic_ai/app/modules/(home)/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_doctor_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/app/modules/(home)/personal_data/views/personal_data_view.dart';

class ProfileDoctorView extends GetView<ProfileDoctorController> {
  const ProfileDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller untuk memanggil fungsi logout
    final homeCtrl = Get.put(HomeController());
    // Mendaftarkan ProfileDoctorController ke dalam memori GetX
    Get.put(ProfileDoctorController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Clinic',
            style: GoogleFonts.inter(
                color: Theme.of(context).textTheme.titleMedium?.color,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Pastikan class LoadingSkeleton tersedia di project-mu
          return const LoadingSkeleton();
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: GoogleFonts.poppins(
                    color: Colors.red[900],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Refresh',
                    style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshProfile();
          },
          color: Theme.of(context).colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- PROFILE SECTION ---
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        backgroundImage:
                            controller.profileImageUrl.value.isNotEmpty
                                ? NetworkImage(controller.profileImageUrl.value)
                                : null,
                        child: controller.profileImageUrl.value.isEmpty
                            ? Icon(Icons.person_outline,
                                color: Theme.of(context).colorScheme.onSurface,
                                size: 30)
                            : null,
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.userName.value,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            Text(
                              controller.userEmail.value,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                try {
                                  Get.toNamed(Routes.ACCOUNT_SETTINGS);
                                } catch (e) {
                                  print('Navigation error: $e');
                                  Get.snackbar(
                                    'Error',
                                    'Unable to navigate to settings',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              child: Text(
                                'View your account settings',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // FIX: Menampilkan Badge ROLE DOCTOR
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          // Jika API memberikan huruf kecil, ubah huruf pertamanya menjadi kapital
                          controller.roleUser.value.isNotEmpty
                              ? controller.roleUser.value[0].toUpperCase() +
                                  controller.roleUser.value.substring(1)
                              : 'Doctor',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),

                  // --- INCOMPLETE DATA CARD (Personal Data Link) ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selesaikan\ndata dokter Anda!',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  'Selesaikan Personal Data di\nprofil kamu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 128,
                              height: 120,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/badge.png')),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // FIX: Menampilkan Spesialisasi dan Deskripsi
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // Menampilkan Specialize dan Degree
                                // "${controller.doctorSpecialize.value} ${controller.doctorDegree.value.isNotEmpty ? '(${controller.doctorDegree.value})' : ''}",
                                "deskripsi dokter",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                // Menampilkan Deskripsi dari Backend
                                controller.doctorDescription.value,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(12),

                        // Tombol ke Personal Data
                        InkWell(
                          onTap: () {
                            try {
                              Get.toNamed(Routes.PERSONAL_DATA);
                            } catch (e) {
                              print('Navigation error: $e');
                              Get.snackbar(
                                'Error',
                                'Unable to navigate to personal data',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Personal Data & Clinic Info',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const Gap(5),
                                Icon(Icons.arrow_forward_ios,
                                    size: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),

                  // --- SETTINGS LIST ---
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Off'),
                    trailing: Obx(() => Switch(
                          value: controller.isDarkMode.value,
                          onChanged: controller.toggleDarkMode,
                        )),
                  ),
                  Divider(color: Theme.of(context).dividerTheme.color),

                  ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Riwayat Pasien'),
                    subtitle: const Text("Your patient diagnosis history"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Pastikan Routes.PATIENS_HISTORY ini sesuai dengan yang kamu daftarkan di app_pages.dart
                      Get.toNamed(Routes.PATIENS_HISTORY);
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    subtitle: const Text('English (Device Language)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help Center'),
                    subtitle: const Text('General help, FAQs, Contact us'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Get.toNamed(Routes.HELP_CENTER);
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    title: const Text('Send Feedback'),
                    subtitle: const Text('Give some feedback'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.info_outlined),
                    title: const Text('About Us'),
                    subtitle: const Text('About Application'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Get.toNamed(Routes.ABOUT_APP);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
