import 'package:clinic_ai/models/appointment_model.dart';
import 'package:get/get.dart';

class AppointmentResultController extends GetxController {
  //TODO: Implement AppointmentResultController
  final Rx<Appointment?> appointment = Rx<Appointment?>(null);
  final RxInt totalAmount = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      appointment.value = args['appointment'] as Appointment?;
      totalAmount.value = args['totalAmount'] as int? ?? 0;
    }
  }

  void goToHome() {
    // Navigate to home or appointment list
    Get.offAllNamed('/home');
  }
}
