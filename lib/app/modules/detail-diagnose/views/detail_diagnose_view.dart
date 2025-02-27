import 'package:clinic_ai/color/color.dart';
import 'package:clinic_ai/components/AIresponse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_diagnose_controller.dart';

class DetailDiagnoseView extends GetView<DetailDiagnoseController> {
  const DetailDiagnoseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('New Appointment'),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: Obx(() {
        // Get appointment data from controller
        final appointment = controller.appointment.value;

        // If appointment is null, show indicator or text
        if (appointment == null) {
          return const Center(
            child: Text('No appointment data'),
          );
        }

        // If appointment is not null, show details
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient section
              const Text(
                'Patient',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Patient Name
              const Text(
                'Patient Name',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.user_name ?? '-',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Patient Code
              const Text(
                'Patient Code',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.qrCode,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Symptoms
              const Text(
                'Symptoms',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Display symptoms list
              if (controller.isLoadingSymptoms.value)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (controller.symptomsList.isEmpty)
                Text(
                  'No symptoms found. ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                )
              else
                Text(
                  controller.symptomsList.map((s) => s.enName).join(', '),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              const SizedBox(height: 16),

              // Symptom Descriptions
              const Text(
                'Symptom Descriptions',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appointment.symptomDescription ?? '-',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),

              // Image Captured section
              const Text(
                'Image Captured',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Image display with validation
              if (controller.isLoadingImage.value)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (controller.hasImage.value)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    controller.capturedImageUrl.value,
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.error_outline, color: Colors.red),
                              SizedBox(height: 8),
                              Text(
                                'Error loading image',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.image_not_supported_outlined,
                            size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'No image uploaded by patient. Please request upload.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Doctor Analyst
              const Text(
                'Doctor Analyst',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.doctorAnalystController,
                decoration: InputDecoration(
                  hintText: 'Ask AI about the symptoms or image...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Submit AI Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.isProcessingAI.value
                      ? null
                      : () => controller.submitAI(),
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: controller.isProcessingAI.value
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Processing...'),
                          ],
                        )
                      : const Text('Submit AI'),
                ),
              ),
              const SizedBox(height: 24),

              // AI Response Section (only shown when there's a response)
              if (controller.aiResponse.value.isNotEmpty) ...[
                const Text(
                  'AI Analysis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: AnimatedAIResponse(
                    response: controller.aiResponse.value,
                    fontSize: 14,
                    lineHeight: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      }),
    );
  }
}
