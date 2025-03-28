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
                            items: controller.doctors
                                .map((doctor) =>
                                    '${doctor.degree} ${doctor.name},${doctor.specialize}')
                                .toList(),
                            onSelected: (String doctorName) {
                              final selectedDoctor =
                                  controller.doctors.firstWhere(
                                (doctor) =>
                                    '${doctor.degree} ${doctor.name},${doctor.specialize}' ==
                                    doctorName,
                                orElse: () => controller.doctors.first,
                              );
                              controller.setDoctor(selectedDoctor);
                              // Get.back();

                              // Navigator.pop(context); // Close dropdown after selection
                            },
                            selectedValue: controller.selectedDoctor.value ==
                                    null
                                ? 'Select Doctor'
                                : '${controller.selectedDoctor.value!.degree} ${controller.selectedDoctor.value!.name},${controller.selectedDoctor.value!.specialize}',
                            isEnabled: controller.selectedPoly.value != null &&
                                !controller.isFormReadOnly
                                    .value, // Disable if form is read-only
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
              Obx(() => controller.isScheduleDateAvailable.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select Date',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        _buildDateField(),
                        const SizedBox(height: 24),
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
                              'Tidak ada jadwal yang tersedia untuk dokter yang anda pilih. Silakan pilih dokter lain atau hubungi klinik.',
                              style: TextStyle(
                                  color: Colors.red[700], fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    )),
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
                            String formattedDate = DateFormat('dd/MM/yyyy')
                                .format(controller.selectedDate.value!);

                            controller.onNextPressed();
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

  Widget _buildDateField() {
    return Obx(() {
      bool isEnabled = controller.selectedDoctor.value != null &&
          !controller.isFormReadOnly.value;

      if (controller.isLoadingScheduleDates.value) {
        return _buildLoadingIndicator();
      }

      List<DateTime> availableDates = controller.scheduleDates
          .map((scheduleDate) => scheduleDate.scheduleDate)
          .toList();

      // Filter tanggal yang sudah lewat
      List<DateTime> validAvailableDates = availableDates
          .where((date) => !date.isBefore(DateTime.now().toLocal()))
          .toList();

      // Tampilkan pesan peringatan jika tidak ada tanggal tersedia (atau semua tanggal sudah lewat) DAN dokter sudah dipilih
      if (validAvailableDates.isEmpty &&
          controller.selectedDoctor.value != null) {
        return Container(
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
                  'Tidak ada jadwal yang tersedia untuk dokter ini. Silakan pilih dokter lain atau hubungi klinik.',
                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                ),
              ),
            ],
          ),
        );
      }

      DateTime? initialDate; // Jadikan nullable

      // Cari tanggal pertama yang tersedia yang tidak sebelum hari ini
      DateTime now = DateTime.now();
      for (DateTime date in validAvailableDates) {
        // Gunakan validAvailableDates
        if (!date.isBefore(DateTime(now.year, now.month, now.day))) {
          initialDate = date;
          break;
        }
      }

      // Jika tidak ada tanggal yang memenuhi syarat, gunakan tanggal pertama dari availableDates (jika ada)
      if (initialDate == null && validAvailableDates.isNotEmpty) {
        // Gunakan validAvailableDates
        initialDate = validAvailableDates.first;
      }

      return InkWell(
        onTap: isEnabled && validAvailableDates.isNotEmpty
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: initialDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                  selectableDayPredicate: (DateTime val) {
                    return validAvailableDates.any((date) =>
                        date.year == val.year &&
                        date.month == val.month &&
                        date.day == val.day);
                  },
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: Theme.of(context).colorScheme,
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
            color: Theme.of(context).inputDecorationTheme.fillColor,
            border: Border.all(
              color: isEnabled
                  ? Theme.of(context)
                      .inputDecorationTheme
                      .enabledBorder!
                      .borderSide
                      .color
                  : Theme.of(context).disabledColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.selectedDate.value != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(controller.selectedDate.value!)
                    : 'Select Date',
                style: TextStyle(
                  color: isEnabled
                      ? (controller.selectedDate.value != null
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Theme.of(context).hintColor)
                      : Theme.of(context).disabledColor,
                ),
              ),
              Icon(
                Icons.calendar_today,
                color: isEnabled
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).disabledColor,
              ),
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
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(Get.context!).textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: (widget.isEnabled && !widget.isReadOnly)
                ? Theme.of(Get.context!).inputDecorationTheme.fillColor
                : Colors.grey[200],
            border: Border.all(
                color: (widget.isEnabled && !widget.isReadOnly)
                    ? Theme.of(Get.context!)
                        .inputDecorationTheme
                        .enabledBorder!
                        .borderSide
                        .color
                    : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(
              widget.selectedValue,
              style: TextStyle(
                color: (widget.isEnabled && !widget.isReadOnly)
                    ? Theme.of(Get.context!).textTheme.bodyLarge?.color
                    : Colors.grey,
              ),
            ),
            enabled: widget.isEnabled && !widget.isReadOnly,
            initiallyExpanded: _isExpanded,
            onExpansionChanged: (expanded) {
              if (expanded && widget.items.isEmpty) {
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
