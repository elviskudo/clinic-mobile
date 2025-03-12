import 'package:clinic_ai/app/modules/(home)/profile/controllers/profile_controller.dart';
import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/components/customdropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/personal_data_controller.dart';

class PersonalDataView extends GetView<PersonalDataController> {
  const PersonalDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileCtrl = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Personal Data',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Get.toNamed(Routes.PROFILE),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? LoadingSkeleton()
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
                        controller.cardNumberController),
                    _buildTextField('Address', 'Enter your address ...',
                        controller.addressController),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              'RT', 'No. RT', controller.rtController),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                              'RW', 'No. RW', controller.rwController),
                        ),
                      ],
                    ),
                    _buildCitySearchField(context),
                    _buildTextField('Postal code', 'Enter your postal code ...',
                        controller.postalCodeController),
                    _buildResponsibleForCostsSection(),
                    _buildBloodTypeDropdown(),
                    SizedBox(height: 16),
                    _buildUpdateButton(context),
                  ],
                ),
              ),
            )),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xff727970), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xff727970), width: 1),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        SizedBox(height: 16),
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
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: dateController,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_today, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xff727970)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xff727970)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: Colors.green,
                    hintColor: Colors.green,
                    colorScheme: ColorScheme.light(primary: Colors.green),
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
        SizedBox(height: 16),
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
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff727970)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  controller.selectedGender.value ?? ' Select Gender',
                  style: TextStyle(color: Color(0xff727970)),
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
            SizedBox(height: 16),
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
          ),
        ),
        SizedBox(height: 8),
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
                          BorderSide(color: Color(0xff727970), width: 1),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: controller.citySearchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
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
                    constraints: BoxConstraints(maxHeight: 200),
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff727970)),
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: controller.isLoadingCities.value
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : controller.cities.isEmpty
                            ? ListTile(
                                title: Text('No results found'),
                                dense: true,
                              )
                            : ListView(
                                shrinkWrap: true,
                                children: controller.cities.map((city) {
                                  return ListTile(
                                    title: Text(
                                      city['village'] ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      [
                                        city['sub_district'],
                                        city['district'],
                                        city['province']
                                      ]
                                          .where(
                                              (e) => e != null && e.isNotEmpty)
                                          .join(', '),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    onTap: () {
                                      controller.selectCity(city);
                                    },
                                    dense: true,
                                  );
                                }).toList(),
                              ),
                  ),
              ],
            )),
        SizedBox(height: 16),
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
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff727970)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  controller.selectedResponsibleForCosts.value ??
                      'Select Responsible for Costs',
                  style: TextStyle(color: Color(0xff727970)),
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
            SizedBox(height: 16),
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
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff727970)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ExpansionTile(
                title: Text(
                  controller.selectedBloodGroup.value ?? 'Select Blood Type',
                  style: TextStyle(color: Color(0xff727970)),
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
            SizedBox(height: 16),
          ],
        ));
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Obx(() => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () async {
                  // Call the saveOrUpdateProfile function
                  await controller.saveOrUpdateProfile(context);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff35693E),
            foregroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 150),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: Color(0xffC1C9BE), width: 1),
            ),
          ),
          child: controller.isLoading.value
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Update',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
  bool _isExpanded = false; // Tambahkan state untuk mengontrol ekspansi

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
            color:
                widget.isEnabled ? const Color(0xffF7FBF2) : Colors.grey[200],
            border: Border.all(
                color:
                    widget.isEnabled ? const Color(0xff727970) : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(
              widget.selectedValue,
              style: TextStyle(
                color: widget.isEnabled ? const Color(0xff727970) : Colors.grey,
              ),
            ),
            enabled: widget.isEnabled,
            initiallyExpanded:
                _isExpanded, // Set ekspansi awal berdasarkan state
            onExpansionChanged: (expanded) {
              if (expanded && widget.items.isEmpty) {
                return;
              }
              setState(() {
                _isExpanded = expanded; // Update state ekspansi
              });
            },
            children: widget.items.map((String item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  widget.onSelected(item);
                  setState(() {
                    _isExpanded = false; // Tutup dropdown
                  });
                  //FocusScope.of(context).unfocus(); // Ini mungkin tidak perlu lagi
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
