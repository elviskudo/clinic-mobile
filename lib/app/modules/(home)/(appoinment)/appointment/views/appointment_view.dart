import 'package:clinic_ai/app/modules/(home)/(appoinment)/appointment/controllers/appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/views/barcode_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/views/capture_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/views/schedule_appointment_view.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/summaryAppointment/controllers/summary_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/views/symptom_appointment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentView extends GetView<AppointmentController> {
  AppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pastikan semua controller dipanggil Get.put disini.
    final scheduleController = Get.put(ScheduleAppointmentController());
    final appointmentController = Get.find<AppointmentController>();
    Get.put(BarcodeAppointmentController());
    final barcodeController = Get.find<BarcodeAppointmentController>();

    final captureController = Get.put(CaptureAppointmentController());
    // final summarycontroller = Get.put(SummaryAppointmentController());

    return DefaultTabController(
      length: 4,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          final PageController pageController = PageController(initialPage: 0);

          scheduleController.setTabController(tabController);

          // Sinkronisasi TabBar dan PageView
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              pageController.jumpToPage(tabController.index);
            }
          });

          pageController.addListener(() {
            if (!pageController.position.haveDimensions) return;
            if (tabController.index != pageController.page?.round()) {
              tabController.animateTo(pageController.page!.round());
            }
          });

          // Fungsi validasi dan perubahan tab
          void validateAndChangeTab(int index, {bool force = false}) {
            if (force) {
              tabController.animateTo(index);
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
              return;
            }

            if (index == 0) {
              tabController.animateTo(index);
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
              return;
            }

            if (index == 1 && !barcodeController.isAccessible.value) {
              Get.snackbar(
                'Warning',
                'Please create an appointment first.',
                snackPosition: SnackPosition.BOTTOM,
              );
              tabController.animateTo(0);
              pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
              return;
            }

            if (index == 3) {
              final appointment = barcodeController.currentAppointment.value;
              if (appointment == null) {
                Get.snackbar(
                  'Information',
                  'Please scan barcode first.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                validateAndChangeTab(1, force: true); // Kembali ke tab QRCode
                return;
              }
              if (!barcodeController.isSymptomsUpdated.value) {
                Get.snackbar(
                  'Information',
                  'Please complete symptom first.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                validateAndChangeTab(2, force: true); // Kembali ke tab Symptom
                return;
              }
            }

            tabController.animateTo(index);
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          }

          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: () {
                  appointmentController.resetAppointmentCreated();
                  scheduleController.resetForm();
                  barcodeController.reset();
                  Get.back();
                },
              ),
              title: Text(
                'Appointment',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Tab(
                    child: Obx(() => Text(
                          'QRCode',
                          style: TextStyle(
                            color: barcodeController.isAccessible.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                        )),
                  ),
                  Tab(
                    child: Obx(() => Text(
                          'Symptom',
                          style: TextStyle(
                            color: barcodeController.isSymptomsUpdated.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                        )),
                  ),
                  Tab(
                    child: Obx(() => Text(
                          'Capture',
                          style: TextStyle(
                            color: barcodeController.isSymptomsUpdated.value
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                        )),
                  ),
                ],
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                indicatorColor: Theme.of(context).colorScheme.primary,
                onTap: (index) {
                  validateAndChangeTab(index);
                },
              ),
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: (index) {
                validateAndChangeTab(index);
              },
              children: [
                ScheduleAppointmentView(),
                BarcodeAppointmentView(),
                SymptomAppointmentView(
                  onTabChange: () {
                    //Berikan Callback
                    tabController.animateTo(3);
                  },
                ),
                CaptureAppointmentView(),
              ],
            ),
          );
        },
      ),
    );
  }
}
