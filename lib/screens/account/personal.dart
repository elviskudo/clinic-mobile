import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/biodata/biodata.dart';
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
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final bio = useBiodataQuery(ref).data;

    final nameCtrl = useTextEditingController(text: bio?.fullName);
    final placeOfBirthCtrl = useTextEditingController(text: bio?.placeOfBirth);
    final dateOfBirthCtrl = useTextEditingController(text: bio?.dateOfBirthStr);
    final citiesCtrl = useTextEditingController(text: bio?.cityStr);
    final nikCtrl = useTextEditingController(text: bio?.nik);
    final addressCtrl = useTextEditingController(text: bio?.address);
    final postalCodeCtrl = useTextEditingController(text: bio?.postalCode);

    final gender = useState<String?>(bio?.gender);
    final responsibleForCosts = useState<String?>(bio?.responsibleForCosts);
    final bloodType = useState<String?>(bio?.bloodType);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('name_field.label')),
              hintText: context.tr('name_field.placeholder'),
            ),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            controller: placeOfBirthCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('place_of_birth_field.label')),
              hintText: context.tr('place_of_birth_field.placeholder'),
            ),
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
            controller: dateOfBirthCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('date_of_birth_field.label')),
              hintText: context.tr('date_of_birth_field.placeholder'),
              suffixIcon: const PhosphorIcon(PhosphorIconsDuotone.calendar),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 120),
                lastDate: DateTime.now(),
                locale: context.locale,
              );
              if (pickedDate != null) {
                dateOfBirthCtrl.text =
                    DateFormat('dd/MM/yyyy').format(pickedDate);
              }
            },
            enableInteractiveSelection: false,
            readOnly: true,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          DropdownButtonFormField(
            value: gender.value,
            decoration: InputDecoration(
              label: Text(context.tr('gender_field.label')),
              hintText: context.tr('gender_field.placeholder'),
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (value) {
              gender.value = value;
            },
          ),
          gapH16,
          TextFormField(
            controller: nikCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('nik_field.label')),
              hintText: context.tr('nik_field.placeholder'),
            ),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            controller: addressCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('address_field.label')),
              hintText: context.tr('address_field.placeholder'),
            ),
            maxLines: 3,
            maxLength: 150,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          CitiesDropdown(controller: citiesCtrl),
          gapH16,
          TextFormField(
            controller: postalCodeCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('postal_code_field.label')),
              hintText: context.tr('postal_code_field.placeholder'),
            ),
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          DropdownButtonFormField(
            decoration: InputDecoration(
              label: Text(context.tr('responsible_costs_field.label')),
              hintText: context.tr('responsible_costs_field.placeholder'),
            ),
            value: responsibleForCosts.value,
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
            onChanged: (value) {
              responsibleForCosts.value = value;
            },
          ),
          gapH16,
          DropdownButtonFormField(
            decoration: InputDecoration(
              label: Text(context.tr('blood_type_field.label')),
              hintText: context.tr('blood_type_field.placeholder'),
            ),
            value: bloodType.value,
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
            onChanged: (value) {
              bloodType.value = value;
            },
            onSaved: (_) {
              debugPrint({
                'name': nameCtrl.text,
                'placeOfBirth': placeOfBirthCtrl.text,
                'dateOfBirth': dateOfBirthCtrl.text,
                'cities': citiesCtrl.text,
                'nik': nikCtrl.text,
                'address': addressCtrl.text,
                'postalCode': postalCodeCtrl.text,
                'gender': gender.value,
                'responsibleForCosts': responsibleForCosts.value,
                'bloodType': bloodType.value,
              }.toString());
            },
          ),
          gapH24,
          SubmitButton(
            onSubmit: () {
              debugPrint({
                'name': nameCtrl.text,
                'placeOfBirth': placeOfBirthCtrl.text,
                'dateOfBirth': dateOfBirthCtrl.text,
                'cities': citiesCtrl.text,
                'nik': nikCtrl.text,
                'address': addressCtrl.text,
                'postalCode': postalCodeCtrl.text,
                'gender': gender.value,
                'responsibleForCosts': responsibleForCosts.value,
                'bloodType': bloodType.value,
              }.toString());
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
