import 'package:clinic_ai/app/modules/(doctor)/detail-diagnose/controllers/detail_diagnose_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/summaryAppointment/controllers/summary_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/personal_data/controllers/personal_data_controller.dart';
import 'package:clinic_ai/app/modules/(home)/personal_data/views/personal_data_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final personalDatCtrl = Get.put(PersonalDataController());
    final summaryCtrl = Get.put(SummaryAppointmentController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      summaryCtrl.getUserSymptoms();
    });
    return Scaffold(
      backgroundColor: Color(0xffF7FBF2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Clinic',
            style: GoogleFonts.inter(
                color: Color(0xff181D18),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () => Get.offAllNamed(Routes.HOME),
          icon: Image.asset('assets/icons/back.png'),
        ),
        backgroundColor: Color(0xffF7FBF2),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return LoadingSkeleton();
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF35693E),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Refresh',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshProfile();
            await summaryCtrl.getUserSymptoms();
          },
          color: Color(0xFF35693E),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Row(
                    children: [
                      Obx(() {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: controller.profileImageUrl.value !=
                                  ''
                              ? NetworkImage(controller.profileImageUrl.value)
                              : null,
                          backgroundColor: Colors.lightGreen[100],
                          child: controller.profileImageUrl.value == ''
                              ? Icon(Icons.person_outline,
                                  color: Colors.black, size: 30)
                              : null,
                        );
                      }),
                      Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                  controller.userName.value,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff181D18),
                                  ),
                                )),
                            Obx(() => Text(
                                  controller.userEmail.value,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Color(0xff181D18),
                                  ),
                                )),
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
                                  color: Color(0xff35693E),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xff35693E),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Obx(() => controller.roleUser.value.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xffD4E8D1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Color(0xFF516351),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                controller.roleUser.value,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Color(0xff516351),
                                ),
                              ),
                            )
                          : SizedBox()),
                    ],
                  ),
                  Gap(16),
                  // Incomplete Data Card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xffF7FBF2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFFC1C9BE),
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
                                  'Segera selesaikan\ndata yang belum\nterselesaikan!',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF39656D),
                                  ),
                                ),
                                Gap(4),
                                Text(
                                  'Selesaikan Personal Data di\nprofil kamu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF39656D),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 128,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/badge.png')),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        // Symptoms section - LIMITED TO 3
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFE8F3FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Diagnosis:",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF39656D),
                                    ),
                                  ),
                                  // Obx(() => summaryCtrl.symptoms.length > 3
                                  //     ? InkWell(
                                  //         onTap: () => _showSymptomsDialog(
                                  //             context, summaryCtrl),
                                  //         child: Text(
                                  //           "Lihat semua",
                                  //           style: GoogleFonts.inter(
                                  //             fontSize: 12,
                                  //             color: Color(0xFF35693E),
                                  //             decoration:
                                  //                 TextDecoration.underline,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : SizedBox()),
                                ],
                              ),
                              Gap(8),
                              Obx(() {
                                if (summaryCtrl.symptoms.isEmpty) {
                                  return Text(
                                    "Belum ada gejala yang dilaporkan",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54,
                                    ),
                                  );
                                } else {
                                  // Only take the first 3 symptoms
                                  final displayedSymptoms =
                                      summaryCtrl.symptoms.length > 3
                                          ? summaryCtrl.symptoms.sublist(0, 3)
                                          : summaryCtrl.symptoms;

                                  return Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            for (int i = 0;
                                                i < displayedSymptoms.length;
                                                i++) ...[
                                              TextSpan(
                                                text: displayedSymptoms[i]
                                                        .enName ??
                                                    "Unknown Symptom",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: Color(0xFF516351),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (i !=
                                                  displayedSymptoms.length -
                                                      1) // Tambahkan koma kecuali di akhir
                                                TextSpan(
                                                  text: ", ",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: Color(0xFF516351),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Image.asset('assets/icons/correct.png'),
                              ),
                            ],
                          ),
                        ),
                        Gap(12),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xffF7FBF2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xffC1C9BE)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  if (personalDatCtrl.isLoading.value) {
                                    return SizedBox();
                                  } else {
                                    return Text(
                                      'Data Personal (${personalDatCtrl.nameController.value.text}, ${personalDatCtrl.cardNumberController.value.text})',
                                      style: TextStyle(
                                          color: Color(0xFF39656D),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    );
                                  }
                                }),
                                Gap(5),
                                Icon(Icons.arrow_forward_ios,
                                    size: 12, color: Color(0xFF39656D)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Settings List
                  ListTile(
                    leading: Icon(Icons.dark_mode),
                    title: Text('Dark Mode'),
                    subtitle: Text('Off'),
                    trailing: Obx(() => Switch(
                          value: controller.isDarkMode.value,
                          onChanged: controller.toggleDarkMode,
                        )),
                  ),
                  Divider(),

                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Riwayat'),
                    subtitle: Text("Doctor's appointments and purchases"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Get.offAllNamed(Routes.MEDICAL_HISTORY);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    subtitle: Text('English (Device Language)'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('Help Center'),
                    subtitle: Text('General help, FAQs, Contact us'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Get.offAllNamed(Routes.HELP_CENTER);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.feedback_outlined),
                    title: Text('Send Feedback'),
                    subtitle: Text('Give some feedback'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.info_outlined),
                    title: Text('About Us'),
                    subtitle: Text('About Application'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Get.offAllNamed(Routes.ABOUT_APP);
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
