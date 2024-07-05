import 'package:clinic/constants/sizes.dart';
import 'package:clinic/features/biodata/biodata.dart';
import 'package:clinic/features/city/city.dart';
import 'package:clinic/widgets/submit_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
    final mutation = useUpdateBiodata(context, ref);

    return Form(
      key: mutation.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: mutation.nameCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('name_field.label')),
              hintText: context.tr('name_field.placeholder'),
            ),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            controller: mutation.placeOfBirthCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('place_of_birth_field.label')),
              hintText: context.tr('place_of_birth_field.placeholder'),
            ),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            controller: mutation.dateOfBirthCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('date_of_birth_field.label')),
              hintText: context.tr('date_of_birth_field.placeholder'),
              suffixIcon: const PhosphorIcon(PhosphorIconsDuotone.calendar),
            ),
            onTap: mutation.handleDateOfBirthChange,
            enableInteractiveSelection: false,
            readOnly: true,
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          DropdownButtonFormField(
            value: mutation.gender,
            decoration: InputDecoration(
              label: Text(context.tr('gender_field.label')),
              hintText: context.tr('gender_field.placeholder'),
            ),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: mutation.handleGenderChange,
          ),
          gapH16,
          TextFormField(
            controller: mutation.nikCtrl,
            decoration: InputDecoration(
              label: Text(context.tr('nik_field.label')),
              hintText: context.tr('nik_field.placeholder'),
            ),
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            controller: mutation.addressCtrl,
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
          CitiesDropdown(
            controller: mutation.citiesCtrl,
            onChanged: mutation.handleCityChange,
          ),
          gapH16,
          TextFormField(
            controller: mutation.postalCodeCtrl,
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
            value: mutation.responsibleForCosts,
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
            onChanged: mutation.handleResponsibleForCostsChange,
          ),
          gapH16,
          DropdownButtonFormField(
            decoration: InputDecoration(
              label: Text(context.tr('blood_type_field.label')),
              hintText: context.tr('blood_type_field.placeholder'),
            ),
            value: mutation.bloodType,
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
            onChanged: mutation.handleBloodTypeChange,
            onSaved: (_) {
              mutation.handleSubmit();
            },
          ),
          gapH24,
          SubmitButton(
            disabled: mutation.isLoading,
            loading: mutation.isLoading,
            onSubmit: mutation.handleSubmit,
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
