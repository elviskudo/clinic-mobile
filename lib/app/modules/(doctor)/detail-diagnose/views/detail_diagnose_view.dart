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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Analysis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text size adjustment controls
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => controller.decreaseFontSize(),
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Text(
                          '${controller.responseFontSize.value.toInt()}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => controller.increaseFontSize(),
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedAIResponse(
                        response: controller.displayedResponse.value,
                        fontSize: controller.responseFontSize.value,
                        lineHeight: 1.5,
                        animate: !controller.isExpandedResponse.value && controller.aiResponse.isEmpty,
                      ),
                      if (controller.aiResponse.value.length >
                          controller.maxCharactersCollapsed) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => controller.toggleResponseView(),
                          child: Text(
                            controller.isExpandedResponse.value
                                ? 'View Less'
                                : 'View More',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Payment Details Section (shown after AI analysis is completed)
              if (controller.showPaymentDetails.value) ...[
                const Text(
                  'Medicine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F5E9), // Light green background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.selectedDrug.value?.name ??
                                    'Paramex',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                controller.selectedDrug.value?.description ??
                                    'Drug Category',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                controller.selectedDrug.value?.dosis ?? '500gr',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.formatCurrency(
                                    controller.selectedDrug.value?.buyPrice ??
                                        12000),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              Text(
                                controller.formatCurrency(
                                    controller.selectedDrug.value?.sellPrice ??
                                        6000),
                                style: const TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => controller.quantity.value++,
                                  color: Colors.green[700],
                                  iconSize: 18,
                                  padding: const EdgeInsets.all(4),
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.green[700],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${controller.quantity.value}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (controller.quantity.value > 1) {
                                      controller.quantity.value--;
                                    }
                                  },
                                  color: Colors.green[700],
                                  iconSize: 18,
                                  padding: const EdgeInsets.all(4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Add Fee Section - Replace with Dropdown
                const Text(
                  'Add Fee',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Fee Dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedFee.value?.id,
                      hint: const Text('Pilih salah satu'),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          final selectedFee = controller.feesList.firstWhere(
                            (fee) => fee.id == newValue,
                            orElse: () => controller.feesList.first,
                          );
                          controller.selectFee(selectedFee);
                        }
                      },
                      items: controller.feesList
                          .map<DropdownMenuItem<String>>((fee) {
                        return DropdownMenuItem<String>(
                          value: fee.id,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(fee.procedure ?? 'Fee'),
                              Text(
                                controller.formatCurrency(fee.price ?? 0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Details with dynamic calculation
                const Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Consultation Fee'),
                          Text(controller.formatCurrency(
                              controller.consultationFee.value)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Handling Fee'),
                          Text(controller
                              .formatCurrency(controller.handlingFee.value)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Medicine (${controller.quantity.value}x)'),
                          Text(controller
                              .formatCurrency(controller.calculateDrugTotal())),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            controller.formatCurrency(
                                controller.calculateGrandTotal()),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Finish Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => controller.finishAppointment(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                    ),
                    child: const Text(
                      'Finish',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
