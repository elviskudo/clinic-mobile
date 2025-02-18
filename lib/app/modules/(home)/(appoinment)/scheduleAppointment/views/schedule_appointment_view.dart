// schedule_appointment_view.dart
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
  final TabController tabController;

  ScheduleAppointmentView({Key? key, required this.tabController})
      : super(key: key);

  @override
  State<ScheduleAppointmentView> createState() => _ScheduleAppointmentViewState();
}

class _ScheduleAppointmentViewState extends State<ScheduleAppointmentView> {
  late ScheduleAppointmentController controller;
  late AppointmentController appointmentController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ScheduleAppointmentController>();
    appointmentController = Get.find<AppointmentController>();

    // Pindahkan logika pengecekan hasCreatedAppointment ke initState
    if (appointmentController.hasCreatedAppointment.value) {
      // Langsung pindah ke tab QR code jika appointment sudah dibuat
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.tabController.animateTo(1);
      });
    }
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
              // Clinic Dropdown
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
                    // Get.back();
                    // Navigator.pop(context); // Close dropdown after selection
                  },
                  selectedValue:
                      controller.selectedClinic.value?.name ?? 'Select Clinic',
                       isEnabled: !controller.isFormReadOnly.value, // Disable if form is read-only
                  isReadOnly: controller.isFormReadOnly.value,
                );
              }),

              // Poly Dropdown
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
                              // Get.back();

                              // Navigator.pop(context); // Close dropdown after selection
                            },
                            selectedValue:
                                controller.selectedPoly.value?.name ??
                                    'Select Poly',
                             isEnabled: controller.selectedClinic.value != null && !controller.isFormReadOnly.value, // Disable if form is read-only
                              isReadOnly: controller.isFormReadOnly.value,
                          ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Tidak ada Poly yang tersedia untuk klinik ini.',
                          style: TextStyle(color: Colors.red)),
                    )),

              // Doctor Dropdown
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
                                .map((doctor) => doctor.degree)
                                .toList(),
                            onSelected: (String doctordegree) {
                              final selectedDoctor =
                                  controller.doctors.firstWhere(
                                (doctor) => doctor.degree == doctordegree,
                                orElse: () => controller.doctors.first,
                              );
                              controller.setDoctor(selectedDoctor);
                              // Get.back();

                              // Navigator.pop(context); // Close dropdown after selection
                            },
                            selectedValue:
                                controller.selectedDoctor.value?.degree ??
                                    'Select Doctor',
                             isEnabled: controller.selectedPoly.value != null && !controller.isFormReadOnly.value, // Disable if form is read-only
                               isReadOnly: controller.isFormReadOnly.value,
                          ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Tidak ada Doctor yang tersedia untuk poly ini.',
                          style: TextStyle(color: Colors.red)),
                    )),

              // Date Selection
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
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Tidak ada Schedule Date yang tersedia untuk doctor ini.',
                          style: TextStyle(color: Colors.red)),
                    )),

              // Time Selection using CustomDropdown
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
                              // Get.back();

                              // Navigator.pop(context); // Close dropdown after selection
                            },
                            selectedValue: controller
                                    .selectedScheduleTime.value?.scheduleTime ??
                                'Select Time',
                            isEnabled:
                                controller.selectedScheduleDateId.value != null && !controller.isFormReadOnly.value, // Disable if form is read-only
                                 isReadOnly: controller.isFormReadOnly.value,
                          ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Tidak ada Schedule Time yang tersedia untuk tanggal ini.',
                          style: TextStyle(color: Colors.red)),
                    )),

              const SizedBox(height: 32),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isFormValid1() && !controller.isFormReadOnly.value // Disable button if form is read-only
                        ? () {
                            controller.onNextPressed(widget.tabController);
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

      // DateTime? initialDate =
      //     availableDates.isNotEmpty ? availableDates.first : null;

      return InkWell(
        onTap: isEnabled
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  // initialDate: initialDate ?? DateTime.now(),
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
                }
              }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xffF7FBF2),
            border: Border.all(color: Color(0xff727970)),
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
                          ? Colors.black
                          : Color(0xff727970))
                      : Colors.grey.shade400,
                ),
              ),
              Icon(Icons.calendar_today,
                  color: isEnabled ? Color(0xff727970) : Colors.grey.shade400),
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
  final bool isReadOnly; // New prop for form read-only state

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.onSelected,
    required this.selectedValue,
    this.isEnabled = true,
    this.isReadOnly = false, // Default to false
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
                    ? const Color(0xff727970)
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
