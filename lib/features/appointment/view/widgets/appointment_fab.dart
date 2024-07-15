import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AppointmentFloatingActionButton extends StatelessWidget {
  const AppointmentFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        WoltModalSheet.show<Locale>(
          context: context,
          useRootNavigator: true,
          useSafeArea: true,
          barrierDismissible: false,
          enableDrag: false,
          pageListBuilder: (context) => [
            _buildCreateAppointmentForm(context),
            _buildCreateAppointmentSuccess(context),
          ],
        );
      },
      icon: const PhosphorIcon(PhosphorIconsRegular.calendarPlus),
      label: const Text('Create Appointment'),
    );
  }
}

SliverWoltModalSheetPage _buildCreateAppointmentForm(BuildContext context) {
  return SliverWoltModalSheetPage(
    hasTopBarLayer: true,
    isTopBarLayerAlwaysVisible: true,
    topBarTitle: Text(
      'Create Appointment',
      style: Theme.of(context).textTheme.titleMedium,
    ),
    mainContentSlivers: [
      SliverToBoxAdapter(
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: () {
                  WoltModalSheet.of(context).showNext();
                },
                child: const Text('Create Appointment'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

SliverWoltModalSheetPage _buildCreateAppointmentSuccess(BuildContext context) {
  return SliverWoltModalSheetPage(
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
