import 'dart:convert';

import 'package:clinic_ai/models/appointment_model.dart';
import 'package:clinic_ai/models/symptom_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final RxList<Symptom> symptomsList = <Symptom>[].obs;
  final RxBool isLoadingSymptoms = RxBool(false);
  final String openRouterApiKey = dotenv.env['AI_API_KEY']!;

  final _supabase = Supabase.instance.client;

  @override
  void onInit() async {
    super.onInit();
    await dotenv.load(fileName: ".env");
    if (Get.arguments != null && Get.arguments is Appointment) {
      appointment.value = Get.arguments as Appointment;
      fetchCapturedImage();
      fetchSymptoms();
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
      aiResponse.value = result;

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

  @override
  void onClose() {
    doctorAnalystController.dispose();
    super.onClose();
  }
}
