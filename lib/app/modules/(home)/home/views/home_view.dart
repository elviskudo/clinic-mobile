import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/medicalHistory/controllers/medical_history_controller.dart';
import 'package:clinic_ai/app/modules/(home)/medicalHistory/views/medical_history_view.dart';
import 'package:clinic_ai/app/modules/(home)/profile/controllers/profile_controller.dart';
import 'package:clinic_ai/app/modules/(home)/profile/views/profile_view.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final ProfileController profileCtrl = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    // PageController to handle swiping between pages
    final PageController pageController = PageController(initialPage: 0);
    Get.put(MedicalHistoryController());
    // Listen to page changes and update the controller index
    pageController.addListener(() {
      if (pageController.page!.round() != controller.currentIndex.value) {
        controller.updateIndex(pageController.page!.round());
      }
    });

    // Listen to controller index changes and update page
    ever(controller.currentIndex, (int index) {
      if (pageController.hasClients && pageController.page!.round() != index) {
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,

      // Gunakan Obx untuk memantau currentIndex
      floatingActionButton: Obx(() => controller.currentIndex.value == 0
          ? _buildAppointmentButton()
          : Container()), // FAB hanya muncul di index 0 (Home), kalau tidak, tampilkan Container kosong

      bottomNavigationBar: _buildBottomBar(pageController),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          controller.updateIndex(index);
        },
        children: [
          _buildHomePage(context),
          MedicalHistoryView(),
          const ProfileView(),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchMedicalRecords();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                        title: 'Medical Record',
                        seeAll: true,
                        child: _buildMedicalRecordsList(),
                        ontap: () => Get.toNamed(Routes.MEDICAL_HISTORY)),
                    const SizedBox(height: 16),
                    _buildSection(
                        title: 'Redeem Medicine',
                        seeAll: true,
                        child: _buildMedicineCards(),
                        ontap: () => Get.toNamed(Routes.MEDICINE_RECORD)),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                child: InkWell(
                  child: Image.asset('assets/images/logo_clinic.png'),
                ),
              ),
              Obx(
                () => IconButton(
                  icon: Icon(
                    Icons.circle_notifications,
                    size: 32,
                    color: controller.isLoggedIn.value
                        ? Theme.of(Get.context!).colorScheme.primary
                        : Theme.of(Get.context!).colorScheme.outline,
                  ),
                  onPressed: () => controller.logout(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (profileCtrl.isLoading.value) {
                    return SizedBox();
                  }
                  return Text(
                    'Greetings on Clinic, ${profileCtrl.user.value.name}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(Get.context!).colorScheme.onBackground,
                    ),
                  );
                }),
                Text(
                  'How are you?',
                  style: GoogleFonts.poppins(
                    color: Theme.of(Get.context!).colorScheme.outline,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
    bool seeAll = false,
    Function()? ontap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (seeAll)
                GestureDetector(
                  onTap: ontap ?? () {},
                  child: Text(
                    'See All',
                    style: GoogleFonts.poppins(
                        color: const Color(0xff35693E),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        decoration: TextDecoration.underline),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildMedicalRecordsList() {
    return Obx(() {
      if (controller.isLoadingMedicalRecords.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.medicalRecords.isEmpty) {
        return const Center(child: Text('No medical records found.'));
      } else {
        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.medicalRecords.length,
            itemBuilder: (context, index) {
              final record = controller.medicalRecords[index];
              final isAlternate = index % 2 == 1;
              return _buildMedicalRecordCard(
                record: record,
                isAlternate: isAlternate,
              );
            },
          ),
        );
      }
    });
  }

  Widget _buildMedicalRecordCard(
      {required Appointment record, required bool isAlternate}) {
    return Container(
      width: MediaQuery.of(Get.context!).size.width * 0.75,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isAlternate
            ? Theme.of(Get.context!).colorScheme.secondaryContainer
            : Theme.of(Get.context!).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            final doctor = controller.existingDoctor.value;
            final poly = controller.existingPoly.value;
            final scheduleDate = controller.existingScheduleDate.value;
            final scheduleTime = controller.existingScheduleTime.value;
            final clinic = controller.existingClinic.value;
            String formattedDate = scheduleDate?.scheduleDate != null
                ? DateFormat('dd MMM yyyy').format(
                    DateTime.parse(scheduleDate!.scheduleDate!.toString()))
                : 'Unknown Date';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: Obx(() => Image.network(
                                controller.doctorProfilePictureUrl.value
                                        .isNotEmpty
                                    ? controller.doctorProfilePictureUrl.value
                                    : 'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  print('Error loading image: $exception');
                                  return const Icon(Icons.error_outline);
                                },
                              )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${doctor?.degree ?? ''} ${doctor?.name ?? ''}, ${doctor?.specialize ?? ''}'
                                      .trim()
                                      .isNotEmpty
                                  ? '${doctor?.degree ?? ''} ${doctor?.name ?? ''}, ${doctor?.specialize ?? ''}'
                                  : 'Unknown Doctor',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              clinic?.name ?? 'Unknown Clinic',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              poly?.name ?? 'Unknown Poly',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.more_horiz, color: Colors.grey[800], size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDate,
                              style: GoogleFonts.poppins(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              scheduleTime?.scheduleTime ?? 'Unknown Time',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.getStatusText(record.status ?? 0),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildMedicineCards() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) => _buildMedicineCard(
          name: index % 2 == 0 ? 'Paramex' : 'Oskadon',
          amount: index % 2 == 0 ? '500gr' : '255trip',
          isAlternate: index % 2 == 1,
        ),
      ),
    );
  }

  Widget _buildMedicineCard({
    required String name,
    required String amount,
    required bool isAlternate,
  }) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAlternate
            ? Theme.of(Get.context!).colorScheme.secondaryContainer
            : Theme.of(Get.context!).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Drug Category',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Completed',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentButton() {
    //final Rx<bool> hasActiveAppointment = false.obs; // Tidak diperlukan lagi
    final Rx<bool> isLoading = true.obs;

    Future<void> checkActiveAppointment() async {
      try {
        isLoading.value = true;
        //final supabase = Supabase.instance.client; // Tidak diperlukan lagi
        //final prefs = await SharedPreferences.getInstance(); // Tidak diperlukan lagi
        //final userId = prefs.getString('userId'); // Tidak diperlukan lagi

        //if (userId != null) { // Tidak diperlukan lagi
        //final response = await supabase // Tidak diperlukan lagi
        // .from('appointments') // Tidak diperlukan lagi
        // .select() // Tidak diperlukan lagi
        //  .eq('user_id', userId) // Tidak diperlukan lagi
        //  .eq('status', 1) // Tidak diperlukan lagi
        //  .limit(1); // Tidak diperlukan lagi

        // hasActiveAppointment.value = response != null && response.isNotEmpty; // Tidak diperlukan lagi
        //}
      } catch (e) {
        print('Error checking appointment: $e');
      } finally {
        isLoading.value = false;
      }
    }

    //checkActiveAppointment(); // Tidak diperlukan lagi

    return SizedBox(
        width: 220,
        child: ElevatedButton(
          // onPressed: isLoading.value
          //     ? null
          //     : () {
          //         //final appointmentController = Get.find<HomeController>(); // Tidak diperlukan lagi
          //         //if (hasActiveAppointment.value) { // Tidak diperlukan lagi
          //         //  appointmentController.setAppointmentCreated(true); // Tidak diperlukan lagi
          //         //}
          //         Get.toNamed(Routes.APPOINTMENT);
          //       },
          onPressed: () => Get.toNamed(Routes.APPOINTMENT),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(Get.context!).colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // child: isLoading.value
          //     ? const SizedBox(
          //         width: 20,
          //         height: 20,
          //         child: CircularProgressIndicator(
          //           strokeWidth: 2,
          //           color: Colors.white,
          //         ),
          //       )
          //     :
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Add Appointment',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildBottomBar(PageController pageController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, top: 8),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBottomBarItem(Icons.home, 0, pageController),
            _buildBottomBarItem(Icons.history, 1, pageController),
            _buildBottomBarItem(Icons.person_outline, 2, pageController),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBarItem(
      IconData icon, int index, PageController pageController) {
    return GestureDetector(
      onTap: () {
        controller.updateIndex(index);
        pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Obx(() => Icon(
            icon,
            color: controller.currentIndex.value == index
                ? Theme.of(Get.context!).iconTheme.color
                : Theme.of(Get.context!).colorScheme.outline,
            size: 24,
          )),
    );
  }
}
