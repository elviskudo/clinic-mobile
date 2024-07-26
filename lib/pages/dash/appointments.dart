import 'package:clinic/features/appointment/presentation/widgets/appointment_card.dart';
import 'package:clinic/pages/dash/home.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

class AppointmentsScreen extends RearchConsumer {
  const AppointmentsScreen({super.key, this.completed = false});

  final bool completed;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final items = use(appointments);

    final filters = [
      'waiting',
      'diagnosed',
      'checkout',
      'completed',
      'rejected'
    ];
    final (currentFilter, setCurrentFilter) = use.state(0);

    final filtered = use.memo(
      () => items.where((a) => a.status == filters[currentFilter]).toList(),
      [items, filters[currentFilter]],
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          primary: true,
          slivers: [
            const SliverToBoxAdapter(child: Divider()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    return _FilterChip(
                      status: filters[index],
                      isActive: currentFilter == index,
                      onPressed: () {
                        setCurrentFilter(index);
                      },
                    );
                  },
                  separatorBuilder: (context, _) => gapW8,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p24,
                vertical: Sizes.p24,
              ),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                itemBuilder: (context, index) => AppointmentCard(
                  appointment: filtered[index],
                ),
                separatorBuilder: (context, index) => gapH16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  // ignore: unused_element
  const _FilterChip({
    required this.status,
    this.isActive = false,
    required this.onPressed,
  });

  final String status;
  final bool isActive;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Chip(
        label: Text(
          toBeginningOfSentenceCase(status),
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.outline,
              ),
        ),
        visualDensity: VisualDensity.compact,
        backgroundColor: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
