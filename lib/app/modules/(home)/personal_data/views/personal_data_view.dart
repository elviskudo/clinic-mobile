import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/personal_data_controller.dart';

class PersonalDataView extends GetView<PersonalDataController> {
  const PersonalDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Personal Data',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            // FIX: Cek role untuk kembali ke halaman profil yang benar
            if (controller.currentUserRole.value == 'doctor') {
              Get.offNamed(Routes.HOME_DOCTOR); // Ganti dengan rute profil dokter jika ada
            } else {
              Get.offNamed(Routes.PROFILE);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const LoadingSkeleton()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                        'Name*', 'John Doe', controller.nameController),
                    _buildTextField('Place of birth*', 'Surabaya',
                        controller.placeOfBirthController),
                    _buildDateField(
                        'Date of birth*', controller.dateOfBirthController),
                    _buildGenderDropdown(),
                    _buildTextField('No. ID card', 'Enter Your ID Number ...',
                        controller.cardNumberController, isNumeric: true),
                    _buildTextField('Address', 'Enter your address ...',
                        controller.addressController),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              'RT', 'No. RT', controller.rtController,
                              isNumeric: true),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                              'RW', 'No. RW', controller.rwController,
                              isNumeric: true),
                        ),
                      ],
                    ),
                    _buildCitySearchField(context),
                    _buildTextField('Postal code', 'Enter your postal code ...',
                        controller.postalCodeController,
                        isNumeric: true),
                    _buildResponsibleForCostsSection(),
                    _buildBloodTypeDropdown(),
                    const SizedBox(height: 24),
                    _buildUpdateButton(context),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController textController,
      {bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(Get.context!).textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
            filled: true,
            fillColor: Theme.of(Get.context!).inputDecorationTheme.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(Get.context!)
                      .inputDecorationTheme
                      .border!
                      .borderSide
                      .color),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(Get.context!)
                      .inputDecorationTheme
                      .enabledBorder!
                      .borderSide
                      .color),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController dateController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(Get.context!).textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: dateController,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.calendar_today,
              size: 20,
              color: Theme.of(Get.context!).textTheme.bodyLarge?.color,
            ),
            filled: true,
            fillColor: Theme.of(Get.context!).inputDecorationTheme.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(Get.context!)
                      .inputDecorationTheme
                      .border!
                      .borderSide
                      .color),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(Get.context!)
                      .inputDecorationTheme
                      .enabledBorder!
                      .borderSide
                      .color),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          readOnly: true,
          onTap: () async {
            FocusScope.of(Get.context!).unfocus();

            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: Colors.green,
                    colorScheme: const ColorScheme.light(primary: Colors.green),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              dateController.text = controller.formatDate(pickedDate);
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    final options = ['Male', 'Female'];

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(Get.context!).textTheme.titleMedium?.color),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff727970)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  controller.selectedGender.value ?? 'Select Gender',
                  style: const TextStyle(color: Colors.black),
                ),
                children: options
                    .map((option) => ListTile(
                          title: Text(option),
                          onTap: () {
                            controller.selectedGender.value = option;
                          },
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildCitySearchField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'City',
          style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Theme.of(Get.context!).textTheme.titleMedium?.color),
        ),
        const SizedBox(height: 8),
        Obx(() => Column(
              children: [
                TextField(
                  controller: controller.citySearchController,
                  decoration: InputDecoration(
                    hintText: 'Search location...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xff727970), width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: controller.citySearchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              controller.citySearchController.clear();
                              controller.cities.clear();
                              controller.showCityList.value = false;
                            },
                          )
                        : null,
                  ),
                ),
                if (controller.showCityList.value)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff727970)),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: controller.isLoadingCities.value
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : controller.cities.isEmpty
                            ? const ListTile(
                                title: Text('No results found'),
                                dense: true,
                              )
                            : ListView(
                                shrinkWrap: true,
                                children: controller.cities.map((city) {
                                  return ListTile(
                                    title: Text(
                                      city['village'] ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      [
                                        city['sub_district'],
                                        city['district'],
                                        city['province']
                                      ]
                                          .where((e) =>
                                              e != null &&
                                              e.toString().isNotEmpty)
                                          .join(', '),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      controller.selectCity(city);
                                    },
                                    dense: true,
                                  );
                                }).toList(),
                              ),
                  ),
              ],
            )),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResponsibleForCostsSection() {
    final options = [
      'KIS / BPJS Kesehatan',
      'BPJS Ketenagakerjaan',
      'Asuransi Umum',
      'Umum',
    ];

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsible for Costs',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(Get.context!).textTheme.titleMedium?.color),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff727970)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  controller.selectedResponsibleForCosts.value ??
                      'Select Responsible for Costs',
                  style: const TextStyle(color: Colors.black),
                ),
                children: options
                    .map((option) => ListTile(
                          title: Text(option),
                          onTap: () {
                            controller.selectedResponsibleForCosts.value =
                                option;
                          },
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildBloodTypeDropdown() {
    final options = ['O', 'A', 'B', 'AB'];

    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Type',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(Get.context!).textTheme.titleMedium?.color),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff727970)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  controller.selectedBloodGroup.value ?? 'Select Blood Type',
                  style: const TextStyle(color: Colors.black),
                ),
                children: options
                    .map((option) => ListTile(
                          title: Text(option),
                          onTap: () {
                            controller.selectedBloodGroup.value = option;
                          },
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  await controller.saveOrUpdateProfile(context);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(Get.context!).colorScheme.primaryContainer,
            foregroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: Color(0xffC1C9BE), width: 1),
            ),
          ),
          child: controller.isLoading.value
              ? CircularProgressIndicator(
                  color: Theme.of(Get.context!).textTheme.bodyMedium?.color)
              : Text(
                  'Update',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(Get.context!).textTheme.bodyMedium?.color,
                  ),
                ),
        ));
  }
}

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(7, (index) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      }),
    );
  }
}