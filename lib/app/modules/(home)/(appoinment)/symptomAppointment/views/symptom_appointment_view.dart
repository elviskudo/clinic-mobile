import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/symptom_appointment_controller.dart';

class SymptomAppointmentView extends GetView<SymptomAppointmentController> {
  const SymptomAppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SymptomAppointmentController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF2),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Expanded(
                    child: Column( // Bungkus Column dengan Expanded
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Symptoms',
                          style: TextStyle(
                            fontSize: viewportConstraints.maxWidth * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: viewportConstraints.maxHeight * 0.02),
                        Obx(() { // Bungkus HANYA bagian loading indicator
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return Wrap( // Hapus Obx disini
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: controller.symptoms.map((symptom) => _buildSymptomButton(
                                symptom,
                                constraints: viewportConstraints,
                                symptomId: symptom.id // Kirimkan ID Gejala
                              )).toList(),
                            );
                          }
                        }),
                        SizedBox(height: viewportConstraints.maxHeight * 0.03),
                        Text(
                          'Symptom Description',
                          style: TextStyle(
                            fontSize: viewportConstraints.maxWidth * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: viewportConstraints.maxHeight * 0.01),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Describe your symptom here ...',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: null,
                            expands: true,
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
                            onPressed: controller.selectedSymptomIds.isNotEmpty && controller.isDescriptionValid.value
                                ? () {
                              controller.updateAppointment();
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF35693E),
                              disabledBackgroundColor: Colors.grey,
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSymptomButton(
      Symptom symptom, {
        required BoxConstraints constraints,
        required String symptomId // Menerima ID Gejala
      }) {
    final controller = Get.find<SymptomAppointmentController>();
    return Obx(() { // Obx HANYA membungkus tombol
      final isSelected = controller.isSymptomSelected[symptomId] ?? false;
      final bool outlined = !isSelected;

      return OutlinedButton(
        onPressed: () {
          controller.toggleSymptom(symptomId);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF35693E),
          backgroundColor: outlined ? Colors.transparent : const Color(0xFF35693E),
          side: outlined
              ? const BorderSide(color: Color(0xFF35693E))
              : BorderSide.none,
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04, vertical: constraints.maxHeight * 0.015),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          symptom.enName,
          style: TextStyle(
            color: outlined ? const Color(0xFF35693E) : Colors.white,
            fontSize: constraints.maxWidth * 0.03,
          ),
        ),
      );
    });
  }
}