import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> items;

  const CustomDropdown({Key? key, required this.label, required this.items, required Function(dynamic value) onSelected, String? value})
      : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String selectedValue; // Menyimpan nilai yang dipilih

  @override
  void initState() {
    super.initState();
    // Set nilai awal berdasarkan label
    selectedValue = 'Select ${widget.label}';
  }

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
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xffF7FBF2),
            border: Border.all(color: Color(0xff727970)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(
              selectedValue,
              style: TextStyle(color: Color(0xff727970)),
            ),
            children: widget.items.map((String item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    selectedValue = item; // Perbarui teks title dengan pilihan
                  });
                  Navigator.pop(context); // Tutup ExpansionTile (Opsional)
                },
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
