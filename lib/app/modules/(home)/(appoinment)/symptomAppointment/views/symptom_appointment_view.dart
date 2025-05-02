import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/symptom_appointment_controller.dart';

class SymptomAppointmentView extends GetView<SymptomAppointmentController> {
  final VoidCallback onTabChange; // Tambahkan callback

  const SymptomAppointmentView({Key? key, required this.onTabChange})
      : super(key: key); // Inisialisasi callback

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SymptomAppointmentController>();
    // Pindahkan pemanggilan loadExistingSymptoms() ke onInit controller

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Symptoms',
                    style: TextStyle(
                      fontSize: viewportConstraints.maxWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color:
                          Theme.of(Get.context!).textTheme.titleMedium?.color,
                    ),
                  ),
                  SizedBox(height: viewportConstraints.maxHeight * 0.02),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: controller.symptoms
                            .map((symptom) => _buildSymptomButton(
                                  symptom,
                                  constraints: viewportConstraints,
                                  symptomId: symptom.id,
                                ))
                            .toList(),
                      );
                    }
                  }),
                  SizedBox(height: viewportConstraints.maxHeight * 0.03),
                  Container(
                    height: 150, // Fixed height for the description field
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Describe your symptom here ...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      initialValue: controller.symptomDescription.value,
                      onChanged: (value) {
                        controller.updateSymptomDescription(value);
                      },
                    ),
                  ),
                  SizedBox(height: viewportConstraints.maxHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(() => ElevatedButton(
                          onPressed: controller.selectedSymptomIds.isNotEmpty &&
                                  controller.isDescriptionValid.value
                              ? () {
                                  controller.updateAppointment().then((_) {
                                    onTabChange(); // Panggil callback setelah update berhasil
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            disabledBackgroundColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSymptomButton(Symptom symptom,
      {required BoxConstraints constraints, required String symptomId}) {
    final controller = Get.find<SymptomAppointmentController>();
    return Obx(() {
      final isSelected = controller.isSymptomSelected[symptomId] ?? false;
      final bool outlined = !isSelected;

      return OutlinedButton(
        onPressed: () {
          controller.toggleSymptom(symptomId);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(Get.context!).colorScheme.primary,
          backgroundColor: outlined
              ? Colors.transparent
              : Theme.of(Get.context!).colorScheme.primary,
          side: outlined
              ? BorderSide(color: Theme.of(Get.context!).colorScheme.primary)
              : BorderSide.none,
          padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.04,
              vertical: constraints.maxHeight * 0.015),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          symptom.enName,
          style: TextStyle(
            color: outlined
                ? Theme.of(Get.context!).colorScheme.primary
                : Theme.of(Get.context!).colorScheme.onPrimary,
            fontSize: constraints.maxWidth * 0.03,
          ),
        ),
      );
    });
  }
}
