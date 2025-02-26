import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/schedule_appointment_controller.dart';
import 'package:intl/intl.dart';
import 'package:clinic_ai/models/clinic_model.dart';
import 'package:clinic_ai/models/poly_model.dart';
import 'package:clinic_ai/models/doctor_model.dart';
import 'package:clinic_ai/models/scheduleTime_model.dart';
import 'package:clinic_ai/app/modules/(home)/(appoinment)/appointment/controllers/appointment_controller.dart';

class ScheduleAppointmentView extends StatefulWidget {
  const ScheduleAppointmentView({Key? key}) : super(key: key);

  @override
  State<ScheduleAppointmentView> createState() =>
      _ScheduleAppointmentViewState();
}

class _ScheduleAppointmentViewState extends State<ScheduleAppointmentView> {
  late ScheduleAppointmentController controller;
  late AppointmentController appointmentController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ScheduleAppointmentController>();
    appointmentController = Get.find<AppointmentController>();
  }

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
              Obx(() {
                if (controller.isLoadingClinics.value) {
                  return _buildLoadingIndicator();
                }
                return CustomDropdown(
                  label: 'Clinic',
                  items:
                      controller.clinics.map((clinic) => clinic.name).toList(),
                  onSelected: (String clinicName) {
                    final selectedClinic = controller.clinics.firstWhere(
                      (clinic) => clinic.name == clinicName,
                      orElse: () => controller.clinics.first,
                    );
                    controller.setClinic(selectedClinic);
                  },
                  selectedValue:
                      controller.selectedClinic.value?.name ?? 'Select Clinic',
                  isEnabled: !controller.isFormReadOnly.value,
                  isReadOnly: controller.isFormReadOnly.value,
                );
              }),
              Obx(() => controller.isPolyAvailable.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.isLoadingPolies.value)
                          _buildLoadingIndicator()
                        else
                          CustomDropdown(
                            label: 'Poly',
                            items: controller.polies
                                .map((poly) => poly.name)
                                .toList(),
                            onSelected: (String polyName) {
                              final selectedPoly = controller.polies.firstWhere(
                                (poly) => poly.name == polyName,
                                orElse: () => controller.polies.first,
                              );
                              controller.setPoly(selectedPoly);
                            },
                            selectedValue:
                                controller.selectedPoly.value?.name ??
                                    'Select Poly',
                            isEnabled:
                                controller.selectedClinic.value != null &&
                                    !controller.isFormReadOnly.value,
                            isReadOnly: controller.isFormReadOnly.value,
                          ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.red[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tidak ada poli yang tersedia untuk klinik yang anda pilih. Silakan pilih klinik lain atau hubungi klinik.',
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )),
              Obx(() => controller.isDoctorAvailable.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.isLoadingDoctors.value)
                          _buildLoadingIndicator()
                        else
                          CustomDropdown(
                            label: 'Doctor',
                            items: controller.doctors.map((doctor) {
                             String doctorDegree = doctor.degree ?? 'Unknown';
                             String doctorName = doctor.name ?? 'Unknown';
                             String doctorSpecialize = doctor.specialize ?? 'Unknown';
                              return  "$doctorDegree $doctorName - $doctorSpecialize";})
                                .toList(),
                             onSelected: (String doctorName) {
                          Doctor? selectedDoctor = controller.doctors.firstWhereOrNull((doctor) {
                               String doctorDegree = doctor.degree ?? 'Unknown';
                             String doctorName2 = doctor.name ?? 'Unknown';
                             String doctorSpecialize = doctor.specialize ?? 'Unknown';
                               return "$doctorDegree $doctorName2 - $doctorSpecialize" == doctorName;
                          });
                           if(selectedDoctor != null){
                                  controller.setDoctor(selectedDoctor);
                           }

                             // final selectedDoctor =
                             //      controller.doctors.firstWhere(
                             //    (doctor) => "${doctor.degree} ${controller.selectedDoctorProfile.value?.name ?? 'N/A'}" == doctorName,
                             //    orElse: () => controller.doctors.first,
                             //  );
                             //  controller.setDoctor(selectedDoctor);
                           },
                           selectedValue:
                           controller.selectedDoctor.value != null ? "${controller.selectedDoctor.value?.degree ?? 'Unknown'} ${controller.selectedDoctor.value?.name ?? 'Unknown'} - ${controller.selectedDoctor.value?.specialize ?? 'Unknown'}"
                                 :'Select Doctor',
                            isEnabled: controller.selectedPoly.value != null &&
                                !controller.isFormReadOnly.value,
                            isReadOnly: controller.isFormReadOnly.value,
                          ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.red[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tidak ada dokter yang tersedia untuk poli yang anda pilih. Silakan pilih poli lain atau hubungi klinik.',
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Date',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Obx(() => _buildDateField(
                      isEnabled: controller.selectedDoctor.value != null &&
                          controller.isScheduleDateAvailable.value)),
                  const SizedBox(height: 24),
                  Obx(() => (controller.selectedClinic.value != null &&
                          controller.selectedPoly.value != null &&
                          controller.selectedDoctor.value != null &&
                          controller.scheduleDates
                              .isEmpty) // Cek jika clinic, poly, dokter dipilih dan tidak ada tanggal yang tersedia
                      ? Container(
                          margin: EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: Colors.red[700], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tidak ada jadwal yang tersedia untuk dokter yang anda pilih. Silakan pilih dokter lain atau hubungi klinik.',
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox()),
                ],
              ),
              Obx(() => controller.isScheduleTimeAvailable.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.isLoadingScheduleTimes.value)
                          _buildLoadingIndicator()
                        else
                          CustomDropdown(
                            label: 'Time',
                            items: controller.scheduleTimes
                                .map((time) => time.scheduleTime)
                                .toList(),
                            onSelected: (String timeString) {
                              final selectedTime =
                                  controller.scheduleTimes.firstWhere(
                                (time) => time.scheduleTime == timeString,
                                orElse: () => controller.scheduleTimes.first,
                              );
                              controller.setSelectedScheduleTime(selectedTime);
                            },
                            selectedValue: controller
                                    .selectedScheduleTime.value?.scheduleTime ??
                                'Select Time',
                            isEnabled:
                                controller.selectedScheduleDateId.value !=
                                        null &&
                                    !controller.isFormReadOnly.value,
                            isReadOnly: controller.isFormReadOnly.value,
                          ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.red[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tidak ada jadwal yang tersedia untuk tanggal yang anda pilih. Silakan pilih tanggal lain atau hubungi klinik.',
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isFormValid1() &&
                            !controller.isFormReadOnly.value
                        ? () async {
                            try {
                              if (controller.selectedDate.value == null) {
                                Get.snackbar(
                                  'Warning',
                                  'Please select a valid date',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }

                              String formattedDate = DateFormat('dd/MM/yyyy')
                                  .format(controller.selectedDate.value!);

                              // await controller.sendNotificationToDoctor(
                              //     doctorId: controller.selectedDoctor.value!.id,
                              //     date: formattedDate,
                              //     time: controller
                              //         .selectedScheduleTime.value!.scheduleTime,
                              //     clinic: controller.selectedClinic.value!.name,
                              //     poly: controller.selectedPoly.value!.name,
                              //     doctorName:
                              //         controller.selectedDoctor.value!.degree);
                              controller.onNextPressed();
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to proceed: ${e.toString()}',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red[100],
                                colorText: Colors.red[800],
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: controller.isFormValid1()
                          ? const Color(0xFF35693E)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Next',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  Widget _buildDateField({required bool isEnabled}) {
    return Obx(() {
      if (controller.isLoadingScheduleDates.value) {
        return _buildLoadingIndicator();
      }

      List<DateTime> availableDates = controller.scheduleDates
          .map((scheduleDate) => scheduleDate.scheduleDate)
          .toList();

      // Find the first available date that's not before today with null safety
      DateTime now = DateTime.now();
      DateTime initialDate = now;
      bool hasValidDate = false;

      // Find the first available date that's today or after
      for (DateTime date in availableDates) {
        if (!date.isBefore(DateTime(now.year, now.month, now.day))) {
          initialDate = date;
          hasValidDate = true;
          break;
        }
      }

      // If no valid dates found, use today's date as fallback
      if (!hasValidDate && availableDates.isNotEmpty) {
        initialDate = availableDates.first;
      }

      return InkWell(
        onTap: isEnabled && availableDates.isNotEmpty
            ? () async {
                try {
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
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.fromSwatch(
                            primarySwatch: Colors.green,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    controller.setSelectedDate(pickedDate);
                    // Check if time slots are available after date selection
                    if (controller.scheduleTimes.isEmpty) {
                      Get.snackbar(
                        'Information',
                        'No time slots available for selected date',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                } catch (e) {
                  // Handle any exceptions that might occur
                  Get.snackbar(
                    'Error',
                    'Failed to open date picker: ${e.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[800],
                  );
                }
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isEnabled && availableDates.isNotEmpty
                ? const Color(0xffF7FBF2)
                : Colors.grey[200],
            border: Border.all(
                color: isEnabled && availableDates.isNotEmpty
                    ? const Color(0xff727970)
                    : Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedDate.value != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.selectedDate.value!)
                    : availableDates.isEmpty
                        ? 'No dates available'
                        : 'Select Date',
                style: TextStyle(
                  color: isEnabled && availableDates.isNotEmpty
                      ? (controller.selectedDate.value != null
                          ? Colors.black
                          : const Color(0xff727970))
                      : Colors.grey.shade400,
                ),
              ),
              Icon(Icons.calendar_today,
                  color: isEnabled && availableDates.isNotEmpty
                      ? const Color(0xff727970)
                      : Colors.grey.shade400),
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

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String) onSelected;
  final String selectedValue;
  final bool isEnabled;
  final bool isReadOnly;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.onSelected,
    required this.selectedValue,
    this.isEnabled = true,
    this.isReadOnly = false,
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
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: (widget.isEnabled && !widget.isReadOnly)
                ? const Color(0xffF7FBF2)
                : Colors.grey[200],
            border: Border.all(
                color: (widget.isEnabled && !widget.isReadOnly)
                    ? const Color(0xff727970)
                    : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(
              widget.selectedValue,
              style: TextStyle(
                color: (widget.isEnabled && !widget.isReadOnly)
                    ? (widget.selectedValue.startsWith('Select')
                        ? const Color(0xff727970)
                        : Colors.black)
                    : Colors.grey,
              ),
            ),
            enabled: widget.isEnabled && !widget.isReadOnly,
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (expanded) {
              if (expanded && widget.items.isEmpty) {
                Get.snackbar(
                  'Information',
                  'No items available to select',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              setState(() {
                _isExpanded = expanded;
              });
            },
            children: widget.items.map((String item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  widget.onSelected(item);
                  setState(() {
                    _isExpanded = false;
                  });
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
