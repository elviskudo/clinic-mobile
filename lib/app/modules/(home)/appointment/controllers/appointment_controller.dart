import 'package:get/get.dart';

class AppointmentController extends GetxController {
  // Add your controller logic here
  final selectedDate = ''.obs;
  final selectedTime = ''.obs;
  final selectedClinic = ''.obs;
  final selectedDoctor = ''.obs;
  
  // Example method for date selection
  void setDate(String date) {
    selectedDate.value = date;
  }
  
  // Add more methods as needed
}