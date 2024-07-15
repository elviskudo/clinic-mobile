import 'package:clinic/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:form_validator/form_validator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rearch/rearch.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AppointmentFAB extends StatelessWidget {
  const AppointmentFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p24),
      child: FloatingActionButton.extended(
        onPressed: () {
          WoltModalSheet.show<Locale>(
            context: context,
            useRootNavigator: true,
            useSafeArea: true,
            barrierDismissible: false,
            pageListBuilder: (context) => [
              _buildCreateAppointment(context),
              _buildCreateAppointmentSuccess(context),
            ],
          );
        },
        icon: const PhosphorIcon(PhosphorIconsRegular.calendarPlus),
        label: const Text('Create Appointment'),
      ),
    );
  }
}

SliverWoltModalSheetPage _buildCreateAppointment(BuildContext context) {
  return SliverWoltModalSheetPage(
    hasTopBarLayer: true,
    isTopBarLayerAlwaysVisible: true,
    enableDrag: true,
    resizeToAvoidBottomInset: true,
    topBarTitle: Text(
      'Create Appointment',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    mainContentSlivers: [
      const SliverPadding(
        padding: EdgeInsets.all(Sizes.p24),
        sliver: SliverToBoxAdapter(
          child: _CreateAppointmentForm(),
        ),
      ),
    ],
  );
}

class _CreateAppointmentForm extends RearchConsumer {
  const _CreateAppointmentForm();

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final formKey = use.memo(() => GlobalKey<FormState>());

    final dateCtrl = use.textEditingController();
    final (date, setDate) = use.state<DateTime?>(null);

    final doctorCtrl = use.textEditingController();
    final (doctor, setDoctor) = use.state<String?>(null);

    final (poly, setPoly) = use.state<String?>(null);
    final (time, setTime) = use.state<String?>(null);

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField(
            validator: ValidationBuilder().required().build(),
            value: poly,
            decoration: const InputDecoration(
              label: Text('Clinic Poly'),
              hintText: 'Pick based on your condition',
            ),
            items: const [
              DropdownMenuItem(
                value: 'vision',
                child: Text('Vision'),
              ),
              DropdownMenuItem(
                value: 'face',
                child: Text('Face'),
              ),
              DropdownMenuItem(
                value: 'tongue',
                child: Text('Tongue'),
              ),
              DropdownMenuItem(
                value: 'mouth',
                child: Text('Mouth'),
              ),
            ],
            onChanged: setPoly,
          ),
          gapH16,
          TextFormField(
            controller: doctorCtrl,
            readOnly: true,
            enabled: poly != null,
            decoration: const InputDecoration(
              label: Text('Doctor'),
              hintText: 'Find available Doctor',
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            validator: ValidationBuilder().required().build(),
            enableInteractiveSelection: false,
            onTap: () async {
              await WoltModalSheet.show(
                context: context,
                useRootNavigator: true,
                useSafeArea: true,
                pageListBuilder: (context) => [
                  SliverWoltModalSheetPage(
                    hasTopBarLayer: true,
                    isTopBarLayerAlwaysVisible: true,
                    topBarTitle: Text(
                      'Find Doctor',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    mainContentSlivers: [
                      SliverList.builder(
                        itemCount: 10,
                        itemBuilder: (ctx, index) {
                          final doctor = Faker.instance.name.fullName();
                          return ListTile(
                            title: Text('Dr. $doctor'),
                            onTap: () {
                              doctorCtrl.text = 'Dr. $doctor';
                              setDoctor('Dr. $doctor');
                              Navigator.pop(context);
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
              );
            },
            textInputAction: TextInputAction.next,
          ),
          gapH16,
          TextFormField(
            controller: dateCtrl,
            enabled: doctor != null,
            decoration: const InputDecoration(
              labelText: 'Schedule Date',
              hintText: 'dd/mm/yy',
              suffixIcon: PhosphorIcon(PhosphorIconsDuotone.calendar),
            ),
            validator: ValidationBuilder().required().build(),
            enableInteractiveSelection: false,
            readOnly: true,
            textInputAction: TextInputAction.next,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
                locale: context.locale,
              );
              if (pickedDate != null) {
                dateCtrl.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                setDate(pickedDate);
              }
            },
          ),
          gapH16,
          DropdownButtonFormField(
            validator: ValidationBuilder().required().build(),
            value: time,
            decoration: const InputDecoration(
              label: Text('Schedule Time'),
              hintText: 'Select appointment time',
            ),
            items: const [
              DropdownMenuItem(
                value: '12:00 - 15:00',
                child: Text('12:00 - 15:00'),
              ),
            ],
            onChanged: date != null ? setTime : null,
          ),
          gapH24,
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                WoltModalSheet.of(context).showNext();
              }
            },
            child: const Text('Submit'),
          ),
          gapH8,
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

SliverWoltModalSheetPage _buildCreateAppointmentSuccess(BuildContext context) {
  return SliverWoltModalSheetPage(
    enableDrag: false,
    isTopBarLayerAlwaysVisible: false,
    hasTopBarLayer: false,
    mainContentSlivers: [
      SliverPadding(
        padding: const EdgeInsets.all(Sizes.p24),
        sliver: SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PhosphorIcon(
                PhosphorIconsDuotone.checkCircle,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              gapH24,
              Text(
                'Create Appointment Success',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              gapH8,
              Text(
                'Your appointment has been queued, please wait while we notify our doctor. You may close this dialog.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.outline),
                textAlign: TextAlign.center,
              ),
              gapH16,
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Go to appointment',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}
