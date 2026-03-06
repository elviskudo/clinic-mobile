import 'dart:async';
import 'dart:convert';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnalyzeDoctorController extends GetxController {
  final isLoading = true.obs;
  final isGeneratingAI = false.obs;
  final isAIDone = false.obs;
  final aiResponseText = ''.obs;

  final appointmentData = <String, dynamic>{}.obs;
  final errorMessage = ''.obs;

  final analystController = TextEditingController();

  // --- FITUR OBAT & BIAYA ---
  final searchMedicineController = TextEditingController();

  final RxList<Map<String, dynamic>> searchResults =
      <Map<String, dynamic>>[].obs;
  final isSearching = false.obs;
  Timer? _debounce;

  final RxList<Map<String, dynamic>> selectedDrugs =
      <Map<String, dynamic>>[].obs;

  // Fee Dropdown
  final feeOptions = [
    {'name': 'Room Fee', 'price': 100000},
    {'name': 'Surgical Fee', 'price': 100000},
    {'name': 'Injection Fee', 'price': 100000},
    {'name': 'Laboratory Fee', 'price': 50000},
  ];
  final RxList<Map<String, dynamic>> selectedFees =
      <Map<String, dynamic>>[].obs;

  final consultationFee = 150000;
  final handlingFee = 30000;

  final String baseUrl = 'https://be-clinic-rx7y.vercel.app';
  final String geminiApiKey = 'AIzaSyBK68EV-y34S-R4LZ9HS4juDdqvhWk21y4';
  late String appointmentId;

  @override
  void onInit() {
    super.onInit();
    appointmentId = Get.arguments ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appointmentId.isNotEmpty) {
        fetchDetail();
      } else {
        errorMessage.value = "ID Janji Temu tidak ditemukan";
        isLoading.value = false;
      }
    });
  }

  Future<void> fetchDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/appointments/doctor/analyze/$appointmentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true) {
          if (decoded['data'] != null) {
            appointmentData
                .assignAll(Map<String, dynamic>.from(decoded['data']));
          }
        } else {
          errorMessage.value = decoded['message'] ?? "Gagal mengambil data";
        }
      } else {
        errorMessage.value = "Gagal mengambil data (${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // ==============================================================
  // MULTIMODAL AI: MENGIRIM TEKS + GAMBAR KE GEMINI
  // ==============================================================
  Future<void> submitAI() async {
    if (appointmentData.isEmpty) {
      Get.snackbar("Error", "Data pasien belum dimuat",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isGeneratingAI.value = true;

    try {
      String symptoms = "Tidak ada";
      if (appointmentData['symptomList'] != null &&
          (appointmentData['symptomList'] as List).isNotEmpty) {
        symptoms = (appointmentData['symptomList'] as List)
            .map((e) => e['id_name'] ?? e['en_name'] ?? '')
            .join(', ');
      }
      String description =
          appointmentData['symptom_description'] ?? 'Tidak ada deskripsi';
      String doctorPrompt = analystController.text;

      String promptText = '''
You are a highly accurate medical/clinical data extraction assistant. Your job is to analyze patient-submitted symptoms (text) and clinical images to produce structured clinical data output.

Here is the patient data:
- Reported Symptoms: $symptoms
- Symptom Description: $description
- Doctor's Notes: $doctorPrompt

RULES:
1. You are NOT a doctor. You do NOT diagnose. You only extract, classify, and map clinical data.
2. If the image is unclear or insufficient, flag it explicitly — never guess.
3. Differentiate between what the patient REPORTS (subjective) and what is VISIBLE in the image (objective).
4. Use standardized medical terminology (ICD-10 keywords where applicable).
5. Confidence level must be provided for every finding (high / medium / low).
6. If symptoms and image are contradictory or unrelated, flag it as "mismatch_warning".
7. Always ask for clarification rather than assume — if critical info is missing, return a "clarification_needed" field.
8. Do NOT hallucinate findings. Only report what is explicitly stated or clearly visible.
9. Respond in the same language as the user's input (Indonesian).
10. IMPORTANT: Do NOT use Markdown formatting like ** or *. Provide plain text only, structured logically.

Provide the response in this exact plain text structure:
SUBJECTIVE (Reported): [Extract from text]
OBJECTIVE (Visible): [Extract from image. Flag if unclear]
CLINICAL MAPPING: [ICD-10 keywords]
CONFIDENCE LEVEL: [High/Medium/Low]
WARNING/CLARIFICATION: [Mismatch or missing info, if any]
RECOMMENDED ACTION: [Brief next steps for the doctor]
''';

      // 1. Siapkan wadah (parts) untuk dikirim ke Gemini
      List<Map<String, dynamic>> promptParts = [
        {"text": promptText}
      ];

      // 2. Cek apakah ada gambar dari pasien
      String? imageUrl = appointmentData['image_url'];

      if (imageUrl != null && imageUrl.isNotEmpty) {
        // CATATAN: Jika 'imageUrl' dari backend hanya berupa nama file (bukan link http lengkap),
        // gabungkan dengan link public Supabase kamu di bawah ini:
        if (!imageUrl.startsWith('http')) {
          // Ganti teks di bawah dengan link bucket Supabase kamu
          String supabaseStorageUrl =
              "https://tcxvtdcvlrqucywsipwi.supabase.co/storage/v1/object/public/appointments/";
          imageUrl = "$supabaseStorageUrl$imageUrl";
        }

        try {
          // Unduh gambar dan ubah jadi Base64
          final imageResponse = await http.get(Uri.parse(imageUrl));
          if (imageResponse.statusCode == 200) {
            String base64Image = base64Encode(imageResponse.bodyBytes);
            String mimeType =
                imageResponse.headers['content-type'] ?? 'image/jpeg';

            // Tambahkan gambar ke dalam wadah (parts)
            promptParts.add({
              "inlineData": {"mimeType": mimeType, "data": base64Image}
            });
            print("Berhasil melampirkan gambar ke Gemini!");
          }
        } catch (e) {
          print("Gagal mendownload gambar untuk AI: $e");
          // Kita abaikan error gambar agar AI tetap bisa menjawab dari teks saja
        }
      }

      // 3. Tembak API Gemini dengan gabungan Teks + Gambar
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$geminiApiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "contents": [
            {"parts": promptParts}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String aiResponse =
            responseData['candidates'][0]['content']['parts'][0]['text'];

        String cleanedResponse = aiResponse
            .replaceAll('**', '')
            .replaceAll('*', '')
            .replaceAll('#', '')
            .trim();

        aiResponseText.value = cleanedResponse;
        isAIDone.value = true;

        Get.snackbar("Berhasil", "Analisa AI berhasil di-generate!",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error AI", "Gagal memanggil Gemini",
            backgroundColor: Colors.orange, colorText: Colors.white);
        print("Gemini Error: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isGeneratingAI.value = false;
    }
  }

  void onSearchMedicineChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchDrugs(query);
    });
  }

  Future<void> fetchDrugs(String keyword) async {
    isSearching.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/drugs?search=$keyword&limit=5'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        var rawData = decoded['data'] ?? decoded;

        if (rawData is Map && rawData.containsKey('data')) {
          rawData = rawData['data'];
        }

        if (rawData is List) {
          searchResults.assignAll(List<Map<String, dynamic>>.from(rawData));
        }
      }
    } catch (e) {
      print("Error search drugs: $e");
    } finally {
      isSearching.value = false;
    }
  }

  void addDrug(Map<String, dynamic> drug) {
    int index =
        selectedDrugs.indexWhere((element) => element['id'] == drug['id']);

    if (index != -1) {
      increaseDrugQty(index);
    } else {
      final newDrug = Map<String, dynamic>.from(drug);
      newDrug['qty'] = 1;
      selectedDrugs.add(newDrug);
    }

    searchMedicineController.clear();
    searchResults.clear();
  }

  void increaseDrugQty(int index) {
    final drug = selectedDrugs.value[index];
    int maxStock = int.tryParse(drug['stock']?.toString() ?? '999') ?? 999;

    if (drug['qty'] < maxStock) {
      drug['qty'] += 1;
      selectedDrugs.refresh();
    }
  }

  void decreaseDrugQty(int index) {
    final drug = selectedDrugs.value[index];

    if (drug['qty'] > 1) {
      drug['qty'] -= 1;
      selectedDrugs.refresh();
    } else {
      selectedDrugs.removeAt(index);
    }
  }

  void addFee(Map<String, dynamic> fee) {
    int existIndex =
        selectedFees.indexWhere((element) => element['name'] == fee['name']);
    if (existIndex == -1) {
      selectedFees.add(fee);
    }
  }

  void removeFee(int index) {
    selectedFees.removeAt(index);
  }

  int get totalMedicinePrice {
    int total = 0;
    for (var drug in selectedDrugs.value) {
      int price = int.tryParse(drug['sell_price']?.toString() ?? '0') ?? 0;
      int qty = drug['qty'] ?? 1;
      total += (price * qty);
    }
    return total;
  }

  int get totalFeeAmount {
    int extraFees = 0;
    for (var fee in selectedFees.value) {
      extraFees += int.tryParse(fee['price']?.toString() ?? '0') ?? 0;
    }
    return consultationFee + handlingFee + extraFees + totalMedicinePrice;
  }

  // ==============================================================
  // FUNGSI FINISH UNTUK MENGIRIM OBAT & FEE KE DATABASE (WITH DEBUG)
  // ==============================================================
  Future<void> finishAnalyze() async {
    try {
      // Tampilkan loading dialog
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      // 1. Format list obat
      List<Map<String, dynamic>> drugsPayload = selectedDrugs.map((drug) {
        return {
          "drug_id": drug['id'],
          "qty": drug['qty'] ?? 1,
          "price": int.tryParse(drug['sell_price']?.toString() ?? '0') ?? 0
        };
      }).toList();

      // 2. Format list fee tambahan
      List<Map<String, dynamic>> feesPayload = selectedFees.map((fee) {
        return {
          "name": fee['name'],
          "price": int.tryParse(fee['price']?.toString() ?? '0') ?? 0
        };
      }).toList();

      // --- DEBUGGING: CEK DATA SEBELUM DIKIRIM ---
      print("===== DEBUG: DATA YANG AKAN DIKIRIM =====");
      print("Drugs Payload: ${json.encode(drugsPayload)}");
      print("Fees Payload: ${json.encode(feesPayload)}");
      print("=========================================");

      // 3. Tembak API
      final response = await http.patch(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'status': 7, // 7 = Completed
          'ai_response': aiResponseText.value,
          'drugs': drugsPayload,
          'fees': feesPayload // MENGIRIM DATA FEE
        }),
      );

      Get.back(); // Tutup loading dialog

      // --- DEBUGGING: CEK RESPONSE DARI BACKEND ---
      print("===== DEBUG: RESPONSE DARI BACKEND =====");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("========================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Sukses",
            "Data berhasil disimpan. Cek terminal/console untuk melihat log fee.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 4));

        // Beri jeda sedikit agar user bisa membaca snackbar sebelum pindah halaman
        await Future.delayed(const Duration(seconds: 2));
        Get.offNamed(Routes.HOME_DOCTOR);
      } else {
        Get.snackbar(
            "Gagal", "Gagal menyimpan data. Status: ${response.statusCode}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back(); // Tutup loading
      Get.snackbar("Error", "Terjadi kesalahan jaringan",
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Error Finish Analyze: $e");
    }
  }

  @override
  void onClose() {
    analystController.dispose();
    searchMedicineController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
