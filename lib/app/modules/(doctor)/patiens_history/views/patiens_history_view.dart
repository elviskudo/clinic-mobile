import 'package:clinic_ai/app/routes/app_pages.dart'; // Tambahkan import ini untuk Routes
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/patiens_history_controller.dart';

class PatiensHistoryView extends GetView<PatiensHistoryController> {
  const PatiensHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Daftarkan controller ke memori
    Get.put(PatiensHistoryController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Riwayat Pasien',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        leading: IconButton(
          // FIX: Tombol back secara eksplisit diarahkan ke route profil dokter/home dokter
          onPressed: () {
            // Sesuaikan dengan nama route profil dokter di app_pages.dart kamu
            Get.offNamed(Routes.HOME_DOCTOR);
          },

          icon: Icon(
            Icons.arrow_back,
            //  color: Theme.of(context).iconTheme.color
            color: Colors.grey[600],
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        // TAMPILAN LOADING
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        // TAMPILAN ERROR
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: GoogleFonts.inter(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text('Coba Lagi',
                      style: GoogleFonts.inter(color: Colors.white)),
                )
              ],
            ),
          );
        }

        // TAMPILAN KOSONG
        if (controller.historyList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada riwayat pasien\nyang ditangani.',
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // TAMPILAN DAFTAR RIWAYAT
        return RefreshIndicator(
          onRefresh: controller.fetchHistory,
          color: Theme.of(context).colorScheme.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.historyList.length,
            itemBuilder: (context, index) {
              final data = controller.historyList[index];
              return _buildHistoryCard(context, data);
            },
          ),
        );
      }),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> data) {
    // Format tanggal
    String dateStr = data['date'] != null ? data['date'].toString() : '';
    if (dateStr.isNotEmpty) {
      try {
        DateTime dt = DateTime.parse(dateStr);
        // Menggunakan intl untuk format (Misal: 14 Feb 2026)
        dateStr = DateFormat('dd MMM yyyy').format(dt);
      } catch (e) {
        // Biarkan string asli jika gagal di-parse
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Selesai',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  data['patientName'] != null &&
                          data['patientName'].toString().isNotEmpty
                      ? data['patientName'][0].toUpperCase()
                      : '?',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['patientName'] ?? 'Unknown Patient',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      data['polyName'] ?? 'General',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Kotak Hasil Diagnosis
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hasil Diagnosis:",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['diagnosis'] ?? 'Tidak ada catatan diagnosis',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    // color: Theme.of(context).textTheme.bodyMedium?.color,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
