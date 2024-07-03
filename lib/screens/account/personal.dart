import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/city/city.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AccountPersonalDataScreen extends StatelessWidget {
  const AccountPersonalDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Data'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Sizes.p24),
          shrinkWrap: true,
          children: const [
            _PersonalDataForm(),
          ],
        ),
      ),
    );
  }
}

class _PersonalDataForm extends HookConsumerWidget {
  const _PersonalDataForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesCtrl = useTextEditingController();

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: Text(context.tr('name_field.label')),
              hintText: context.tr('name_field.placeholder'),
            ),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            decoration: const InputDecoration(label: Text('Place of birth')),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          // InputDatePickerFormField(
          //   fieldLabelText: 'Date of birth',
          //   firstDate: DateTime(DateTime.now().year - 120),
          //   lastDate: DateTime.now(),
          //   acceptEmptyDate: false,
          // ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Date of birth'),
              suffixIcon: PhosphorIcon(PhosphorIconsDuotone.calendar),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 120),
                lastDate: DateTime.now(),
                locale: context.locale,
              );
              if (pickedDate == null) return;
            },
            enableInteractiveSelection: false,
            readOnly: true,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          DropdownButtonFormField(
            decoration: const InputDecoration(
              label: Text('Gender'),
              hintText: 'Select gender',
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (value) {},
          ),
          gapH16,
          TextFormField(
            decoration: const InputDecoration(label: Text('No. ID Card')),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Address'),
              hintText: 'Enter your address...',
            ),
            maxLines: 3,
            maxLength: 150,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          CitiesDropdown(
            controller: citiesCtrl,
          ),
          gapH16,
          TextFormField(
            decoration: const InputDecoration(
              label: Text('Postal Code'),
              hintText: 'Enter your postal code...',
            ),
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          DropdownButtonFormField(
            decoration: const InputDecoration(
              label: Text('Responsible for Costs'),
              hintText: 'Pilih salah satu',
            ),
            value: 'normal',
            items: const [
              DropdownMenuItem(
                value: 'bpjs_1',
                child: Text('KIS / BPJS Kesehatan'),
              ),
              DropdownMenuItem(
                value: 'bpjs_2',
                child: Text('BPJS Ketenagakerjaan'),
              ),
              DropdownMenuItem(
                value: 'insurance',
                child: Text('Asuransi Umum'),
              ),
              DropdownMenuItem(
                value: 'normal',
                child: Text('Umum'),
              ),
            ],
            onChanged: (value) {},
          ),
          gapH16,
          DropdownButtonFormField(
            decoration: const InputDecoration(
              label: Text('Blood Type'),
              hintText: 'Select blood type...',
            ),
            items: const [
              DropdownMenuItem(
                value: 'a',
                child: Text('A'),
              ),
              DropdownMenuItem(
                value: 'b',
                child: Text('B'),
              ),
              DropdownMenuItem(
                value: 'ab',
                child: Text('AB'),
              ),
              DropdownMenuItem(
                value: 'o',
                child: Text('O'),
              ),
            ],
            onChanged: (value) {},
            onSaved: (value) {},
          ),
          gapH24,
          SubmitButton(
            onSubmit: () {},
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
