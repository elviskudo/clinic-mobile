// appointment_view.dart
import 'package:clinic_ai/app/modules/(home)/(appoinment)/appointment/controllers/appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/views/barcode_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/views/capture_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/views/schedule_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/views/symptom_appointment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentView extends GetView<AppointmentController> {
  AppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.find<ScheduleAppointmentController>();
    final appointmentController = Get.find<AppointmentController>(); // ADD THIS
    Get.put(BarcodeAppointmentController());
    final barcodeController = Get.find<BarcodeAppointmentController>();
    final symptomController = Get.find<SymptomAppointmentController>();
    final captureController = Get.find<CaptureAppointmentController>();

    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          final PageController pageController = PageController(); // Tambahkan PageController

          // Fungsi validasi yang akan digunakan di TabBar dan PageView
          void validateAndChangeTab(int index) {
            if (index == 0) {
              return;
            }

            if (index == 1 && !barcodeController.isAccessible.value) {
              Get.snackbar(
                'Warning',
                'Please create an appointment first.',
                snackPosition: SnackPosition.BOTTOM,
              );
              tabController.animateTo(0);
              pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease); // Kembali ke halaman 0
              return;
            }

            if (index == 2) {
              final appointment =
                  barcodeController.currentAppointment.value;
              if (appointment?.status != 1) {
                Get.snackbar(
                  'Information',
                  'Please complete QR code scanning first.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                if (barcodeController.isAccessible.value) {
                  tabController.animateTo(1);
                   pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
                } else {
                  tabController.animateTo(0);
                   pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                }
                return;
              }
            }

            if (index == 3) {
              Get.snackbar(
                'Information',
                'Please complete symptom form first.',
                snackPosition: SnackPosition.BOTTOM,
              );
              tabController.animateTo(2);
               pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.ease);
              return;
            }
            // Jika semua validasi lolos, pindah ke halaman yang dipilih
            tabController.animateTo(index);
             pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF7FBF2),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  // Reset the form and barcode data when the back button is pressed
                  appointmentController.resetAppointmentCreated(); // ADD THIS
                  scheduleController.resetForm();
                  barcodeController.reset(); // Reset BarcodeController
                  Get.back();
                },
              ),
              title: const Text(
                'Appointment',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                //Hapus physics: const NeverScrollableScrollPhysics(),
                tabs: [
                  const Tab(
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                        color: Color(0xFF35693E),
                      ),
                    ),
                  ),
                  Tab(
                    child: Obx(() => Text(
                          'QRCode',
                          style: TextStyle(
                            color: barcodeController.isAccessible.value
                                ? const Color(0xFF35693E)
                                : Colors.grey,
                          ),
                        )),
                  ),
                  const Tab(
                    child: Text(
                      'Symptom',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Tab(
                    child: Text(
                      'Capture',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
                labelColor: const Color(0xFF35693E),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF35693E),
                onTap: (index) {
                  validateAndChangeTab(index);
                },
              ),
            ),
            body: PageView( //Ganti TabBarView dengan PageView
              controller: pageController,
              onPageChanged: (index) {
               validateAndChangeTab(index);
              },
              children: [
                ScheduleAppointmentView(tabController: tabController),
                BarcodeAppointmentView(),
                SymptomAppointmentView(),
                CaptureAppointmentView(),
              ],
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     scheduleController.onNextPressed(tabController);
            //   },
            //   child: const Icon(Icons.arrow_forward),
            // ),
          );
        },
      ),
    );
  }
}