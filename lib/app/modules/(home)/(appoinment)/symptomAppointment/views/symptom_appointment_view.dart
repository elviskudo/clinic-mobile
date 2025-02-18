import 'package:clinic_ai/app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/symptom_appointment_controller.dart';

class SymptomAppointmentView extends GetView<SymptomAppointmentController> {
  const SymptomAppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     Get.put(ScheduleAppointmentController());
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Symptoms',
                        style: TextStyle(
                          fontSize: viewportConstraints.maxWidth * 0.04, // Responsive font size
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: viewportConstraints.maxHeight * 0.02), // Responsive height
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          _buildSymptomButton('Lorem', constraints: viewportConstraints),
                          _buildSymptomButton('Lorem', constraints: viewportConstraints),
                          _buildSymptomButton('Lorem Ips', constraints: viewportConstraints),
                          _buildSymptomButton('Lorem Ipsum', constraints: viewportConstraints),
                          _buildSymptomButton('Dolor Sit', outlined: true, constraints: viewportConstraints),
                          _buildSymptomButton('Dolor Sit', outlined: true, constraints: viewportConstraints),
                          _buildSymptomButton('Amet', constraints: viewportConstraints),
                          _buildSymptomButton('Ips', outlined: true, constraints: viewportConstraints),
                          _buildSymptomButton('Amet', constraints: viewportConstraints),
                          _buildSymptomButton('Lorem Ips', constraints: viewportConstraints),
                          _buildSymptomButton('Lorem Ipsum Dolor', constraints: viewportConstraints),
                          _buildSymptomButton('Lorem', outlined: true, constraints: viewportConstraints),
                          _buildSymptomButton('Amet', constraints: viewportConstraints),
                          _buildSymptomButton('Choose Opt', constraints: viewportConstraints),
                          _buildSymptomButton('Choose Opt', constraints: viewportConstraints),
                          _buildSymptomButton('Ips', outlined: true, constraints: viewportConstraints),
                          _buildSymptomButton('Ips', outlined: true, constraints: viewportConstraints),
                          _buildSymptomButton('Lorem Ipsum Dolor', outlined: true, constraints: viewportConstraints),
                          _buildSymptomButton('Choose Opt', outlined: true, constraints: viewportConstraints),
                        ],
                      ),
                      SizedBox(height: viewportConstraints.maxHeight * 0.03), // Responsive height
                      Text(
                        'Symptom Description',
                        style: TextStyle(
                          fontSize: viewportConstraints.maxWidth * 0.04, // Responsive font size
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: viewportConstraints.maxHeight * 0.01), // Responsive height
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Describe your symptom here ...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null, // Allow unlimited lines
                          expands: true, // Expand to fill available space
                        ),
                      ),
                      SizedBox(height: viewportConstraints.maxHeight * 0.03), // Responsive height
                     SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          
                        },
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
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSymptomButton(String label, {bool outlined = false, required BoxConstraints constraints}) {
    return OutlinedButton(
      onPressed: () {
        // Add your logic here
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF35693E),
        backgroundColor: outlined ? Colors.transparent : const Color(0xFF35693E),
        side: outlined
            ? const BorderSide(color: Color(0xFF35693E))
            : BorderSide.none,
        padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.04, vertical: constraints.maxHeight * 0.015), // Responsive padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: outlined ? const Color(0xFF35693E) : Colors.white,
          fontSize: constraints.maxWidth * 0.03, // Responsive font size
        ),
      ),
    );
  }
}