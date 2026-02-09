import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';
import 'package:get/get.dart';

import '../controllers/appointment_controller.dart';

class AppointmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppointmentController());
    // GANTI KE Get.put BIAR API fetchClinics() LANGSUNG JALAN
    Get.put(ScheduleAppointmentController());
    Get.put(BarcodeAppointmentController());
    Get.put(SymptomAppointmentController());
    Get.put(CaptureAppointmentController());
  }
}

// class AppointmentBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => AppointmentController());

//     // Tambahkan fenix: true untuk controller utama yang handle API awal
//     Get.lazyPut(() => ScheduleAppointmentController(), fenix: true);

//     Get.lazyPut(() => BarcodeAppointmentController(), fenix: true);
//     Get.lazyPut(() => SymptomAppointmentController(), fenix: true);
//     Get.lazyPut(() => CaptureAppointmentController(), fenix: true);
//   }
// }
