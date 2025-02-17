import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';
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
