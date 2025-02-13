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
    Get.put(ScheduleAppointmentController);
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
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isFormValid() ? controller.onNextPressed : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF35693E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                )),
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
      return InkWell(

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    controller.selectedClinic.value?.name ?? 'Select Clinic ...',
                    style: TextStyle(color: controller.selectedClinic.value != null ? Colors.black : Colors.grey),
                  ),
                ),
              ),
              PopupMenuButton<Clinic>(
                onSelected: (Clinic clinic) {
                  controller.setClinic(clinic);
                },
                itemBuilder: (BuildContext context) {
                  return controller.clinics.map((Clinic clinic) {
                    return PopupMenuItem<Clinic>(
                      value: clinic,
                      child: Text(clinic.name),
                    );
                  }).toList();
                },
                 child: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ),
            ],
          ),
        ),
        onTap: (){
          print('hello');
        },
      );
    });
  }

  Widget _buildPolyDropdown() {
    return Obx(() {
      if (controller.isLoadingPolies.value) {
        return _buildLoadingIndicator();
      }

      return InkWell(
        onTap: (){
          print('hello');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    controller.selectedPoly.value?.name ?? 'Pilih salah satu',
                    style: TextStyle(color: controller.selectedPoly.value != null ? Colors.black : Colors.grey),
                  ),
                ),
              ),
              PopupMenuButton<Poly>(

                onSelected: controller.selectedClinic.value != null
                    ? (Poly poly) {
                  controller.setPoly(poly);
                }
                    : null,
                itemBuilder: (BuildContext context) {
                  return controller.polies.map((Poly poly) {
                    return PopupMenuItem<Poly>(
                      value: poly,
                      child: Text(poly.name),
                    );
                  }).toList();
                },
                 child: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDoctorDropdown() {
    return Obx(() {
      if (controller.isLoadingDoctors.value) {
        return _buildLoadingIndicator();
      }

      return InkWell(
        onTap: (){
          print('hello');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    controller.selectedDoctor.value?.name ?? 'Select Doctor ...',
                    style: TextStyle(color: controller.selectedDoctor.value != null ? Colors.black : Colors.grey),
                  ),
                ),
              ),
              PopupMenuButton<Doctor>(

                onSelected: controller.selectedClinic.value != null && controller.selectedPoly.value != null
                    ? (Doctor doctor) {
                  controller.setDoctor(doctor);
                }
                    : null,
                itemBuilder: (BuildContext context) {
                  return controller.doctors.map((Doctor doctor) {
                    return PopupMenuItem<Doctor>(
                      value: doctor,
                      child: Text(doctor.name),
                    );
                  }).toList();
                },
                 child: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    });
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

    return GetBuilder<ScheduleAppointmentController>( // Tambahkan GetBuilder
      builder: (controller) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: isEnabled
                  ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                  selectableDayPredicate: (DateTime val) {
                    return availableDates.any((date) =>
                    date.year == val.year &&
                        date.month == val.month &&
                        date.day == val.day);
                  },
                );

                if (pickedDate != null) {
                  controller.setSelectedDate(pickedDate);
                  controller.update(); // Panggil update untuk memicu rebuild
                }
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
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20, color: isEnabled ? Colors.grey : Colors.grey.shade400),
                        const SizedBox(width: 8),
                        Text(
                          controller.selectedDate.value != null
                              ? DateFormat('dd/MM/yyyy').format(controller.selectedDate.value!)
                              : 'DD/MM/YYYY',
                          style: TextStyle(color: isEnabled ? Colors.grey.shade600 : Colors.grey.shade400),
                        ),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_down, color: isEnabled ? Colors.grey : Colors.grey.shade400),
                  ],
                ),
              ),
            );
          },
        );
      },
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
        onTap: isEnabled ? () {
          // Tampilkan BottomSheet atau dialog untuk pilihan waktu
          showModalBottomSheet(
            context: Get.context!,
            builder: (context) {
              return ListView.builder(
                itemCount: controller.scheduleTimes.length,
                itemBuilder: (context, index) {
                  final time = controller.scheduleTimes[index];
                  return ListTile(
                    title: Text(time.scheduleTime),
                    onTap: () {
                      controller.setSelectedScheduleTime(time);
                      Navigator.pop(context); // Tutup BottomSheet
                    },
                  );
                },
              );
            },
          );
        } : null,
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
                controller.selectedScheduleTime.value?.scheduleTime ?? 'Select Time',
                style: TextStyle(color: isEnabled ? Colors.grey.shade600 : Colors.grey.shade400),
              ),
              Icon(Icons.keyboard_arrow_down, color: isEnabled ? Colors.grey : Colors.grey.shade400),
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