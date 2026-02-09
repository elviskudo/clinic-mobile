import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/schedule_appointment_controller.dart';
import 'package:intl/intl.dart';

class ScheduleAppointmentView extends GetView<ScheduleAppointmentController> {
  const ScheduleAppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleAppointmentController>();
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          controller.resetForm();
          return Future.value();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. CLINIC ---
              Obx(() {
                if (controller.isLoadingClinics.value) return _buildLoading();
                return CustomDropdown(
                  label: 'Clinic',
                  items: controller.clinics.map((e) => e.name ?? '').toList(),
                  selectedValue:
                      controller.selectedClinic.value?.name ?? 'Select Clinic',
                  isEnabled: !controller.isFormReadOnly.value,
                  onSelected: (val) {
                    final clinic =
                        controller.clinics.firstWhere((e) => e.name == val);
                    controller.setClinic(clinic);
                  },
                );
              }),

              // --- 2. POLY ---
              Obx(() {
                if (!controller.isPolyAvailable.value)
                  return _buildWarning('Tidak ada poli tersedia.');
                if (controller.isLoadingPolies.value) return _buildLoading();

                return CustomDropdown(
                  label: 'Poly',
                  items: controller.polies.map((e) => e.name ?? '').toList(),
                  selectedValue:
                      controller.selectedPoly.value?.name ?? 'Select Poly',
                  isEnabled: controller.selectedClinic.value != null &&
                      !controller.isFormReadOnly.value,
                  onSelected: (val) {
                    final poly =
                        controller.polies.firstWhere((e) => e.name == val);
                    controller.setPoly(poly);
                  },
                );
              }),

              // --- 3. DOCTOR ---
              Obx(() {
                if (!controller.isDoctorAvailable.value)
                  return _buildWarning('Tidak ada dokter tersedia.');
                if (controller.isLoadingDoctors.value) return _buildLoading();

                return CustomDropdown(
                  label: 'Doctor',
                  items: controller.doctors
                      .map((e) => '${e.name} (${e.specialize})')
                      .toList(),
                  selectedValue: controller.selectedDoctor.value != null
                      ? '${controller.selectedDoctor.value!.name} (${controller.selectedDoctor.value!.specialize})'
                      : 'Select Doctor',
                  isEnabled: controller.selectedPoly.value != null &&
                      !controller.isFormReadOnly.value,
                  onSelected: (val) {
                    // Cari dokter yg stringnya cocok (agak tricky kalau nama sama, idealnya pake ID di UI tapi Dropdown string based)
                    final doctor = controller.doctors.firstWhere(
                        (e) => '${e.name} (${e.specialize})' == val);
                    controller.setDoctor(doctor);
                  },
                );
              }),

              // --- 4. DATE ---
              Obx(() {
                if (!controller.isScheduleDateAvailable.value)
                  return _buildWarning('Jadwal dokter kosong.');
                if (controller.isLoadingScheduleDates.value)
                  return _buildLoading();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Date',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    _buildDateField(context),
                    const SizedBox(height: 16),
                  ],
                );
              }),

              // --- 5. TIME ---
              Obx(() {
                if (!controller.isScheduleTimeAvailable.value)
                  return _buildWarning('Jam praktek penuh/kosong.');
                if (controller.isLoadingScheduleTimes.value)
                  return _buildLoading();

                return CustomDropdown(
                  label: 'Time',
                  items: controller.scheduleTimes
                      .map((e) => e.scheduleTime ?? '')
                      .toList(),
                  selectedValue:
                      controller.selectedScheduleTime.value?.scheduleTime ??
                          'Select Time',
                  isEnabled: controller.selectedDate.value != null &&
                      !controller.isFormReadOnly.value,
                  onSelected: (val) {
                    final time = controller.scheduleTimes
                        .firstWhere((e) => e.scheduleTime == val);
                    controller.setSelectedScheduleTime(time);
                  },
                );
              }),

              const SizedBox(height: 32),

              // --- BUTTON NEXT ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isFormValid() &&
                              !controller.isFormReadOnly.value
                          ? () => controller.onNextPressed()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF35693E),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Next',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Center(child: CircularProgressIndicator(color: Color(0xFF35693E))),
    );
  }

  Widget _buildWarning(String msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.red[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(msg, style: TextStyle(color: Colors.red[700]))),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: controller.selectedDoctor.value != null &&
              !controller.isFormReadOnly.value
          ? () async {
              // 1. Ambil daftar tanggal valid dari controller
              final availableDates =
                  controller.scheduleDates.map((e) => e.scheduleDate!).toList();

              // Urutkan tanggal agar yang paling awal ada di posisi pertama
              availableDates.sort((a, b) => a.compareTo(b));

              if (availableDates.isEmpty) {
                Get.snackbar(
                    'Informasi', 'Tidak ada jadwal tersedia untuk dokter ini.');
                return;
              }

              // 2. FIX: Tentukan initialDate yang VALID.
              // Harus ada di dalam availableDates agar tidak crash.
              final DateTime initialValidDate = availableDates.first;

              final picked = await showDatePicker(
                context: context,
                // Gunakan initialValidDate, jangan gunakan DateTime.now() jika hari ini dokter tidak praktek
                initialDate: initialValidDate,
                // Set firstDate ke tanggal pertama yang tersedia agar kalender ngebuka di bulan yang bener
                firstDate: initialValidDate.isBefore(DateTime.now())
                    ? initialValidDate
                    : DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                selectableDayPredicate: (day) {
                  // Hanya boleh pilih tanggal yang ada di database (tersedia di list)
                  return availableDates.any((avail) =>
                      avail.year == day.year &&
                      avail.month == day.month &&
                      avail.day == day.day);
                },
              );

              if (picked != null) {
                controller.setSelectedDate(picked);
              }
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
                  controller.selectedDate.value != null
                      ? DateFormat('dd/MM/yyyy')
                          .format(controller.selectedDate.value!)
                      : 'Select Date',
                  style: TextStyle(
                      color: controller.selectedDate.value != null
                          ? Colors.black
                          : Colors.grey),
                )),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Custom Dropdown Widget (Taruh di file terpisah atau di bawah sini)
class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String) onSelected;
  final String selectedValue;
  final bool isEnabled;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.onSelected,
    required this.selectedValue,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: widget.isEnabled ? Colors.white : Colors.grey[200],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(widget.selectedValue,
                style: TextStyle(
                    color: widget.isEnabled ? Colors.black : Colors.grey)),
            trailing: widget.isEnabled
                ? const Icon(Icons.arrow_drop_down)
                : const SizedBox(),
            onExpansionChanged: (expanded) {
              if (widget.isEnabled) setState(() => _isExpanded = expanded);
            },
            initiallyExpanded: widget.isEnabled && _isExpanded,
            children: widget.items
                .map((item) => ListTile(
                      title: Text(item),
                      onTap: () {
                        widget.onSelected(item);
                        setState(() => _isExpanded = false);
                      },
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
