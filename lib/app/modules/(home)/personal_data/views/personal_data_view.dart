// lib/app/modules/personal_data/views/personal_data_view.dart

import 'package:clinic_ai/app/routes/app_pages.dart';
import 'package:clinic_ai/components/customdropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/personal_data_controller.dart';

class PersonalDataView extends GetView<PersonalDataController> {
  const PersonalDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7FBF2),
      appBar: AppBar(
        backgroundColor: Color(0xffF7FBF2),
        title: Text(
          'Personal Data',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Name*', 'John Doe'),
              CustomDropdown(
                  label: 'Place of birth*', items: ['Jakarta', 'Surabaya']),
              _buildDateField('Date of birth*', '06/17/2004'),
              CustomDropdown(label: 'Gender', items: ['Male', 'Female']),
              _buildTextField('No. ID card', 'Enter Your ID Number ...'),
              _buildTextField('Address', 'Enter your address ...'),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('RT', 'No. RT'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('RW', 'No. RW'),
                  ),
                ],
              ),
              CustomDropdown(label: 'City', items: ['Jakarta', 'Surabaya']),
              _buildTextField('Postal code', 'Enter your postal code ...'),
              _buildExpandableSection('Responsible for Costs', [
                'KIS / BPJS Kesehatan',
                'BPJS Ketenagakerjaan',
                'Asuransi Umum',
                'Umum',
              ]),
              CustomDropdown(label: 'Blood Type', items: ['O', 'A', 'B', 'AB']),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Handle update
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: const BorderSide(color: Color(0xffC1C9BE), width: 1),
                  ),
                ),
                child: Text(
                  'Update',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff35693E)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
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

  Widget _buildDateField(String label, String initialValue) {
    TextEditingController _controller =
        TextEditingController(text: initialValue);

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
          controller: _controller,
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
              _controller.text =
                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            }
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExpandableSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
            title: Text('Pilih salah satu',
                style: TextStyle(color: Color(0xff727970))),
            children: options
                .map((option) => ListTile(
                      title: Text(option),
                      onTap: () {},
                    ))
                .toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
