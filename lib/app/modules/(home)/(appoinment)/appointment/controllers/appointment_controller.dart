// appointment_controller.dart
import 'package:clinic_ai/app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  // Add your controller logic here
  final selectedDate = ''.obs;
  final selectedTime = ''.obs;
  final selectedClinic = ''.obs;
  final selectedDoctor = ''.obs;
    RxBool hasCreatedAppointment = false.obs;
      void enableSymptomTab() {
    final barcodeController = Get.find<BarcodeAppointmentController>();
    barcodeController.isAccessible.value = true;
  }
   void setAppointmentCreated(bool value) {
    hasCreatedAppointment.value = value;
  }
    // Reset Method
  void resetAppointmentCreated() {
    hasCreatedAppointment.value = false;
  }
  // Example method for date selection
  void setDate(String date) {
    selectedDate.value = date;
  }
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
  
  // Add more methods as needed
}