import 'dart:convert';

import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/drug_model.dart';
import 'package:clinic_ai/models/fee_model.dart';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailDiagnoseController extends GetxController {
  final TextEditingController doctorAnalystController = TextEditingController();
  final Rx<Appointment?> appointment = Rx<Appointment?>(null);
  final RxString capturedImageUrl = RxString('');
  final RxBool isLoadingImage = RxBool(false);
  final RxBool hasImage = RxBool(false);
  final RxBool isProcessingAI = RxBool(false);
  final RxString aiResponse = RxString('');
  final RxDouble responseFontSize = RxDouble(14.0); // For adjustable text size
  final RxBool hasAnimatedResponse = RxBool(false);

  // Payment section variables
  final RxList<Fee> feesList = <Fee>[].obs;
  final RxBool showPaymentDetails = RxBool(false);
  final RxInt quantity = RxInt(1);
  final RxInt consultationFee = RxInt(50000);
  final RxInt handlingFee = RxInt(30000);

  final RxList<Symptom> symptomsList = <Symptom>[].obs;
  final RxBool isLoadingSymptoms = RxBool(false);
  final String openRouterApiKey =
      "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";
  final RxBool isLoadingFees = RxBool(false);
  final RxBool isLoadingDrugs = RxBool(false);
  final RxList<Drug> drugsList = <Drug>[].obs;
  final Rx<Drug?> selectedDrug = Rx<Drug?>(null);
  final Rx<Fee?> selectedFee = Rx<Fee?>(null);
  final RxBool isExpandedResponse = RxBool(false);
  final RxString displayedResponse = RxString('');
  final int maxCharactersCollapsed = 200;

  final _supabase = Supabase.instance.client;
  final currencyFormatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void onInit() async {
    super.onInit();
    await dotenv.load(fileName: ".env");
    if (Get.arguments != null && Get.arguments is Appointment) {
      appointment.value = Get.arguments as Appointment;
      fetchCapturedImage();
      fetchSymptoms();
      fetchDrugs(); // Fetch drugs from table
      fetchFees();
    }
  }

  // Increase font size
  void increaseFontSize() {
    if (responseFontSize.value < 24.0) {
      responseFontSize.value += 2.0;
    }
  }

  // Decrease font size
  void decreaseFontSize() {
    if (responseFontSize.value > 10.0) {
      responseFontSize.value -= 2.0;
    }
  }

  Future<void> fetchFees() async {
    isLoadingFees.value = true;

    try {
      // Fetch active fees from Supabase
      final response =
          await _supabase.from('fees').select('*').eq('status', true);

      if (response != null) {
        // Convert the response to a list of Fee objects
        final List<Fee> fees = (response as List<dynamic>)
            .map((json) => Fee.fromJson(json as Map<String, dynamic>))
            .toList();

        feesList.assignAll(fees);
        print('Fees list loaded: ${feesList.length} fees');
      }
    } catch (e) {
      print('Error fetching fees: $e');
      Get.snackbar(
        'Error',
        'Failed to load fees: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFees.value = false;
    }
  }

  void toggleResponseView() {
    isExpandedResponse.value = !isExpandedResponse.value;
    updateDisplayedResponse();
  }

// Update the displayed response based on expanded state
  void updateDisplayedResponse() {
    if (aiResponse.value.isEmpty) {
      displayedResponse.value = '';
      return;
    }

    if (isExpandedResponse.value ||
        aiResponse.value.length <= maxCharactersCollapsed) {
      displayedResponse.value = aiResponse.value;
    } else {
      // Truncate and add ellipsis
      displayedResponse.value =
          '${aiResponse.value.substring(0, maxCharactersCollapsed)}...';
    }
  }

// Call this whenever aiResponse is updated
  void onAIResponseUpdated(String response) {
    aiResponse.value = response;
    hasAnimatedResponse.value = false;
    updateDisplayedResponse();
  }

  Future<void> fetchDrugs() async {
    isLoadingDrugs.value = true;

    try {
      // Fetch drugs from Supabase
      final response = await _supabase.from('drugs').select('*');

      if (response != null) {
        // Convert the response to a list of Drug objects
        final List<Drug> drugs = (response as List<dynamic>)
            .map((json) => Drug.fromJson(json as Map<String, dynamic>))
            .toList();

        drugsList.assignAll(drugs);

        // Select the first drug as default if available
        if (drugs.isNotEmpty) {
          selectedDrug.value = drugs.first;
        }

        print('Drugs list loaded: ${drugsList.length} drugs');
      }
    } catch (e) {
      print('Error fetching drugs: $e');
      Get.snackbar(
        'Error',
        'Failed to load drugs: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingDrugs.value = false;
    }
  }

  Future<void> fetchCapturedImage() async {
    if (appointment.value == null) return;

    isLoadingImage.value = true;

    try {
      // Query the files table to find the image related to this appointment
      final response = await _supabase
          .from('files')
          .select('file_name')
          .eq('module_class', 'appointments')
          .eq('module_id', appointment.value!.id)
          .maybeSingle();

      if (response != null && response['file_name'] != null) {
        capturedImageUrl.value = response['file_name'];
        hasImage.value = true;
      } else {
        hasImage.value = false;
      }
    } catch (e) {
      print('Error fetching image: $e');
      hasImage.value = false;
    } finally {
      isLoadingImage.value = false;
    }
  }

  Future<void> fetchSymptoms() async {
    isLoadingSymptoms.value = true;

    try {
      // Parse the comma-separated symptom IDs as strings (not integers)
      final symptomIds = appointment.value!.symptoms!
          .split(',')
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toList();

      if (symptomIds.isEmpty) {
        return;
      }

      // Fetch symptoms from Supabase based on string IDs
      final response = await _supabase
          .from('symptoms')
          .select('*')
          .inFilter('id', symptomIds);

      if (response != null) {
        // Convert the response to a list of Symptom objects
        final List<Symptom> symptoms = (response as List<dynamic>)
            .map((json) => Symptom.fromJson(json as Map<String, dynamic>))
            .toList();

        symptomsList.assignAll(symptoms);
        print('symptom list: ${symptomsList.value}');
      }
    } catch (e) {
      print('Error fetching symptoms: $e');
      Get.snackbar(
        'Error',
        'Failed to load symptoms: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingSymptoms.value = false;
    }
  }

  // Function to submit data to AI
  Future<void> submitAI() async {
    if (appointment.value == null) return;

    // Jika Anda ingin memaksa keberadaan gambar:
    if (!hasImage.value) {
      Get.snackbar(
        'Error',
        'No image available for analysis',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final translator = GoogleTranslator();

    // Ambil analisis dokter dari TextField
    String doctorAnalysis = doctorAnalystController.text.trim();
    if (doctorAnalysis.isEmpty) {
      doctorAnalysis = "No preliminary analysis from the doctor provided.";
    }

    final translationDoctor = await translator.translate(
      doctorAnalysis,
      from: 'id',
      to: 'en',
    );

    final translationSymtomDesc = await translator.translate(
      appointment.value?.symptomDescription ?? "-",
      from: 'id',
      to: 'en',
    );

    // Bangun prompt sesuai keinginan
    // Pastikan menyesuaikan penulisan, spasi, dll. dengan kebutuhan Anda
    String finalPrompt = """
As a medical AI assistant, your task is to analyze and provide a comprehensive diagnosis based on the following inputs:

1) Symptoms reported by the patient (separated by commas): ${symptomsList.map((s) => s.enName).join(', ') ?? ""}
   With detailed symptom descriptions: ${translationSymtomDesc.text ?? ""}

2) Images provided by the patient (URL): ${capturedImageUrl.value}

3) A doctor's preliminary analysis regarding the patient's condition: ${translationDoctor.text}

Using this data, provide a well-informed diagnosis, treatment plan, and suggest any immediate steps or referrals required. 
Make sure to highlight urgent conditions and offer advice on whether home care is sufficient or the patient needs to seek further 
medical attention. Ensure that the analysis is accurate, medically sound, and offers clear next steps for the patient's care.
""";

    isProcessingAI.value = true;

    try {
      // Kirim prompt kustom ke AI
      String result = await getAIAnalysis(finalPrompt, capturedImageUrl.value);
      onAIResponseUpdated(result);

      // Update the appointment record in Supabase with the AI response
      await updateAppointmentWithAIResponse(result);

      // Show payment details after successful AI analysis
      showPaymentDetails.value = true;

      Get.snackbar(
        'Success',
        'AI analysis completed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error processing AI request: $e');
      Get.snackbar(
        'Error',
        'Failed to process AI request: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingAI.value = false;
    }
  }

  // Update the appointment with AI response in Supabase
  Future<void> updateAppointmentWithAIResponse(String aiResponseText) async {
    if (appointment.value == null) return;

    try {
      await _supabase.from('appointments').update(
          {'ai_response': aiResponseText}).eq('id', appointment.value!.id);

      print('Successfully updated appointment with AI response');
    } catch (e) {
      print('Error updating appointment with AI response: $e');
      // We don't show a snackbar here since the AI analysis was successful
      // and we don't want to confuse the user with an error message about the update
    }
  }

  Future<void> finishAppointment() async {
    try {
      // Update appointment status to 5 and ensure AI response is saved
      await _supabase
          .from('appointments')
          .update({'status': 5, 'ai_response': aiResponse.value}).eq(
              'id', appointment.value!.id);

      Get.snackbar(
        'Success',
        'Appointment and prescription finalized',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed(
      Routes.APPOINTMENT_RESULT,
      arguments: {
        'appointment': appointment.value,
        'totalAmount': calculateGrandTotal(),
      },
    );

      // Navigate back to previous screen
      Get.back();
    } catch (e) {
      print('Error finalizing appointment: $e');
      Get.snackbar(
        'Error',
        'Failed to finalize appointment: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String> getAIAnalysis(String prompt, String imageUrl) async {
    try {
      var headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $openRouterApiKey"
      };

      var body = {
        "model": "google/gemini-2.0-pro-exp-02-05:free",
        "messages": [
          {
            "role": "user",
            "content": [
              {"type": "text", "text": prompt},
              {
                "type": "image_url",
                "image_url": {"url": imageUrl}
              }
            ]
          }
        ],
        "temperature": 0
      };

      final response = await http.post(
          Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
          headers: headers,
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null &&
            data['choices'] != null &&
            data['choices'].isNotEmpty &&
            data['choices'][0]['message'] != null &&
            data['choices'][0]['message']['content'] != null) {
          print("API Response: ${response.body}");
          print("Data: $data");
          print("Choices: ${data['choices']}");
          return data['choices'][0]['message']['content'];
        } else {
          return "Error: Received invalid response format from API";
        }
      } else {
        return "Request failed with status: ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      print('Exception in getAIAnalysis: $e');
      return "Error: $e";
    }
  }

  void updateConsultationFee() {
    if (selectedFee.value != null) {
      consultationFee.value = selectedFee.value!.price ?? 50000;
    }
  }

  // Select a fee from dropdown
  void selectFee(Fee fee) {
    selectedFee.value = fee;
    updateConsultationFee();
  }

  // Select a drug
  void selectDrug(Drug drug) {
    selectedDrug.value = drug;
  }

  // Calculate total drug price
  int calculateDrugTotal() {
    if (selectedDrug.value != null) {
      return (selectedDrug.value!.buyPrice ?? 0) * quantity.value;
    }
    return 0;
  }

  String formatCurrency(int amount) {
    return currencyFormatter.format(amount);
  }

  // Calculate grand total
  int calculateGrandTotal() {
    return consultationFee.value + handlingFee.value + calculateDrugTotal();
  }

  // Finalize the appointment and paymen

  @override
  void onClose() {
    doctorAnalystController.dispose();
    super.onClose();
  }
}
