import 'package:clinic_ai/app/modules/(home)/personal_data/controllers/personal_data_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final personalDataCtrl = Get.put(PersonalDataController());
    return Scaffold(
      backgroundColor: Color(0xffF7FBF2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Clinic',
            style: GoogleFonts.inter(
                color: Color(0xff181D18),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        backgroundColor: Color(0xffF7FBF2),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Row(
                children: [
                  Obx(() => CircleAvatar(
                        radius: 30,
                        backgroundImage: controller.user.value.imageUrl != ''
                            ? NetworkImage(controller.user.value.imageUrl!)
                            : null,
                        backgroundColor: Colors.lightGreen[100],
                        child: controller.user.value.imageUrl == ''
                            ? Icon(Icons.person_outline,
                                color: Colors.black, size: 30)
                            : null,
                      )),
                  Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              controller.user.value.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff181D18),
                              ),
                            )),
                        Obx(() => Text(
                              controller.user.value.email,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Color(0xff181D18),
                              ),
                            )),
                        InkWell(
                          onTap: () {
                            Get.offAllNamed(Routes.ACCOUNT_SETTINGS);
                          },
                          child: Text(
                            'View your account settings',
                            style: TextStyle(
                              color: Color(0xff35693E),
                              decoration: TextDecoration
                                  .underline, // Tambahkan garis bawah
                              decorationColor: Color(
                                  0xff35693E), // Warna garis bawah mengikuti teks
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffD4E8D1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFF516351), // Warna border
                        width: 2, // Ketebalan border
                      ),
                    ),
                    child: Obx(() => Text(
                          controller.user.value.role,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Color(0xff516351),
                          ),
                        )),
                  ),
                ],
              ),
              Gap(16),
              // Incomplete Data Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xffF7FBF2), // Changed to white background
                  borderRadius:
                      BorderRadius.circular(16), // Increased border radius
                  border: Border.all(
                    color: Color(0xFFC1C9BE), // Warna border
                    width: 1, // Ketebalan border
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
                                color: Color(
                                    0xFF39656D), // Added specific blue color
                              ),
                            ),
                            Gap(4),
                            Text(
                              'Selesaikan Personal Data di\nprofil kamu',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(
                                    0xFF39656D), // Added specific grey color
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 128,
                          height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/badge.png')),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    // Diagnosis Item
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F3FF), // Light blue background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Diagnosis (Alergi, Riwayat Trauma ...)',
                            style: TextStyle(
                              color: Color(0xFF2C5C71),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Image.asset('assets/icons/correct.png'),
                        ],
                      ),
                    ),
                    Gap(12),
                    // Personal Data Item
                    InkWell(
                      onTap: () {
                        Get.offAllNamed(Routes.PERSONAL_DATA);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xffF7FBF2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xffC1C9BE)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                'Data Personal (${personalDataCtrl.cardNumberController.value})',
                                style: TextStyle(
                                    color: Color(0xFF39656D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Gap(5),
                            Row(
                              children: [
                                Text(
                                  'String value',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                Gap(8),
                                Icon(Icons.arrow_forward_ios,
                                    size: 12, color: Color(0xFF39656D)),
                              ],
                            ),
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
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Riwayat'),
                subtitle: Text("Doctor's appointments and purchases"),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
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
                onTap: () {},
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.feedback_outlined),
                title: Text('Kirim umpan balik'),
                subtitle: Text('Give some feedback'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
