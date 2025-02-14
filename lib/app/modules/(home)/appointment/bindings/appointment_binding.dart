import 'package:clinic_ai/app/modules/(home)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:get/get.dart';

import '../controllers/appointment_controller.dart';

class AppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppointmentController());
    Get.lazyPut(() => ScheduleAppointmentController());
    Get.lazyPut(() => BarcodeAppointmentController());
    Get.lazyPut(() => SymptomAppointmentController());
    Get.lazyPut(() => CaptureAppointmentController());
  }
}
