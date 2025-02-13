import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/schedule_appointment_controller.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:intl/intl.dart';

class ScheduleAppointmentView extends GetView<ScheduleAppointmentController> {
  const ScheduleAppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          return Future.value();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Clinic', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _buildClinicDropdown(),
              const SizedBox(height: 24),

              Obx(() => controller.isPolyAvailable.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Poly', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildPolyDropdown(),
                  const SizedBox(height: 24),
                ],
              )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tidak ada Poly yang tersedia untuk klinik ini.', style: TextStyle(color: Colors.red)),
                  )),

              Obx(() => controller.isDoctorAvailable.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Doctor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildDoctorDropdown(),
                  const SizedBox(height: 24),
                ],
              )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tidak ada Doctor yang tersedia untuk poly ini.', style: TextStyle(color: Colors.red)),
                  )),

              Obx(() => controller.isScheduleDateAvailable.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildDateField(),
                  const SizedBox(height: 24),
                ],
              )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tidak ada Schedule Date yang tersedia untuk doctor ini.', style: TextStyle(color: Colors.red)),
                  )),

              Obx(() => controller.isScheduleTimeAvailable.value
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildDropdownField('Select Time'),
                  const SizedBox(height: 32),
                ],
              )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Tidak ada Schedule Time yang tersedia untuk tanggal ini.', style: TextStyle(color: Colors.red)),
                  )),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isFormValid1() ? () {
                      controller.onNextPressed();
                    } : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: controller.isFormValid1() ? const Color(0xFF35693E) : Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClinicDropdown() {
    return Obx(() {
      if (controller.isLoadingClinics.value) {
        return _buildLoadingIndicator();
      }
      return _buildDropdown<Clinic>(
        hintText: 'Select Clinic ...',
        value: controller.selectedClinic.value,
        items: controller.clinics,
        onSelected: (Clinic clinic) {
          controller.setClinic(clinic);
        },
        itemText: (Clinic clinic) => clinic.name,
      );
    });
  }

  Widget _buildPolyDropdown() {
    return Obx(() {
      if (controller.isLoadingPolies.value) {
        return _buildLoadingIndicator();
      }

      return _buildDropdown<Poly>(
        hintText: 'Select Poly ...',
        value: controller.selectedPoly.value,
        items: controller.polies,
        onSelected:  (controller.selectedClinic.value != null) ?(Poly poly) { //Menambahkan tanda tanya
          controller.setPoly(poly);
        }:(Poly poly){},
        itemText: (Poly poly) => poly.name,
      );
    });
  }

  Widget _buildDoctorDropdown() {
    return Obx(() {
      if (controller.isLoadingDoctors.value) {
        return _buildLoadingIndicator();
      }

      return _buildDropdown<Doctor>(
        hintText: 'Select Doctor ...',
        value: controller.selectedDoctor.value,
        items: controller.doctors,
        onSelected: (controller.selectedClinic.value != null && controller.selectedPoly.value != null)?(Doctor doctor) { //Menambahkan tanda tanya
          controller.setDoctor(doctor);
        }: (Doctor doctor){},
        itemText: (Doctor doctor) => doctor.name,
      );
    });
  }
  Widget _buildDropdown<T>({
    required String hintText,
    required T? value,
    required List<T> items,
    required Function(T) onSelected,
    required String Function(T) itemText,
  }) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: Get.context!,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              margin: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        itemText(item),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value != null ? itemText(value) : hintText,
                style: TextStyle(color: value != null ? Colors.black : Colors.grey),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }


 Widget _buildDateField() {
    return Obx(() {
      bool isEnabled = controller.selectedDoctor.value != null;

      if (controller.isLoadingScheduleDates.value) {
        return _buildLoadingIndicator();
      }

      List<DateTime> availableDates = controller.scheduleDates
          .map((scheduleDate) => scheduleDate.scheduleDate)
          .toList();

      DateTime? initialDate = availableDates.isNotEmpty ? availableDates.first : null;

      return InkWell(
        onTap: isEnabled
            ? () async {
          DateTime? pickedDate = await showDatePicker(
            context: Get.context!,
            initialDate: initialDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 1),
            selectableDayPredicate: (DateTime val) {
              return availableDates.any((date) =>
              date.year == val.year &&
                  date.month == val.month &&
                  date.day == val.day);
            },
            builder: (BuildContext context, Widget? child) { // Tambahkan builder
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.green, // Ubah warna primer
                  ),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            controller.setSelectedDate(pickedDate);
          }
        }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : Colors.grey.shade200, // Atur warna background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedDate.value != null
                    ? DateFormat('dd/MM/yyyy').format(controller.selectedDate.value!)
                    : 'Select Date', // Teks hint
                style: TextStyle(
                  color: isEnabled
                      ? (controller.selectedDate.value != null ? Colors.black : Colors.grey)
                      : Colors.grey.shade400, // Warna teks
                ),
              ),
              Icon(Icons.calendar_today, color: isEnabled ? Colors.grey : Colors.grey.shade400), // Ikon kalender
            ],
          ),
        ),
      );
    });
  }


   Widget _buildDropdownField(String hint) {
    return Obx(() {
      bool isEnabled = controller.selectedScheduleDateId.value != null;

      if (controller.isLoadingScheduleTimes.value) {
        return _buildLoadingIndicator();
      }

      return InkWell(
        onTap: isEnabled
            ? () {
          showModalBottomSheet(
            context: Get.context!,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.only(top: 50),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.scheduleTimes.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final time = controller.scheduleTimes[index];
                    return InkWell(
                      onTap: () {
                        controller.setSelectedScheduleTime(time);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          time.scheduleTime,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isEnabled ? Colors.white : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedScheduleTime.value?.scheduleTime ?? hint, // Menggunakan hint sebagai placeholder
                style: TextStyle(
                  color: isEnabled
                      ? (controller.selectedScheduleTime.value != null ? Colors.black : Colors.grey)
                      : Colors.grey.shade400,
                ),
              ),
              Icon(Icons.access_time, color: isEnabled ? Colors.grey : Colors.grey.shade400), // Menggunakan ikon waktu
            ],
          ),
        ),
      );
    });
  }
   Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF35693E)),
          ),
        ),
      ),
    );
  }
}