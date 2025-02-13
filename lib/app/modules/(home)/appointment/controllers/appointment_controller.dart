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
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
  
  // Add more methods as needed
}