import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/features/appointment/domain/appointment.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p16).copyWith(bottom: Sizes.p8),
            child: Row(
              children: [
                Text(
                  'Poly ${toBeginningOfSentenceCase(appointment.poly)}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600),
                ),
                gapW16,
                _AppointmentStatus(appointment: appointment),
              ],
            ),
          ),
          gapH8,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: _DoctorInfo(appointment: appointment),
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Text(
              DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                  .format(appointment.createdAt),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorInfo extends StatelessWidget {
  const _DoctorInfo({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: CircleAvatar(
            child: WebsafeSvg.network(
              'https://api.dicebear.com/8.x/notionists/svg?seed=${appointment.doctor}',
            ),
          ),
        ),
        gapW8,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Dr. ${appointment.doctor}',
              style: Theme.of(context).textTheme.titleMedium,
              minFontSize: 16,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            gapH4,
            Text(
              appointment.clinic,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      ],
    );
  }
}

class _AppointmentStatus extends StatelessWidget {
  const _AppointmentStatus({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        toBeginningOfSentenceCase(appointment.status),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor:
          Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(99),
        side: BorderSide(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
