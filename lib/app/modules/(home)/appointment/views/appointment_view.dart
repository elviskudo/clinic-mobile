// appointment_view.dart
import 'package:clinic_ai/app/modules/(home)/appointment/controllers/appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/barcodeAppointment/views/barcode_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/captureAppointment/views/capture_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/views/schedule_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/symptomAppointment/views/symptom_appointment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentView extends GetView<AppointmentController> {
  AppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleController = Get.find<ScheduleAppointmentController>();
    Get.put(BarcodeAppointmentController());
    final barcodeController = Get.find<BarcodeAppointmentController>();
    final symptomController = Get.find<SymptomAppointmentController>();
    final captureController = Get.find<CaptureAppointmentController>();

    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          return Scaffold(
            backgroundColor: const Color(0xFFF7FBF2),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
              title: const Text(
                'Appointment',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                physics: const NeverScrollableScrollPhysics(),
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
                    return;
                  }

                  if (index > 1) {
                    Get.snackbar(
                      'Information',
                      'Please proceed with the QRCode tab first.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    if (barcodeController.isAccessible.value) {
                      tabController.animateTo(1);
                    } else {
                      tabController.animateTo(0);
                    }
                    return;
                  }
                },
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
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