import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/features/appointment/appointment.dart';
import 'package:clinic/features/clinic/clinic.dart';
import 'package:clinic/features/profile/profile.dart';
import 'package:clinic/pages/dash/dash_router.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:go_router/go_router.dart';
import 'package:rearch/rearch.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppointmentFAB(),
      body: SafeArea(
        child: CustomScrollView(
          primary: true,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(Sizes.p24).copyWith(
                top: 0,
                bottom: 16,
              ),
              sliver: const SliverToBoxAdapter(
                child: _WelcomeText(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24)
                  .copyWith(bottom: Sizes.p32),
              sliver: const SliverToBoxAdapter(
                child: Text(
                  'How\'s your heath? Let\'s start by making appointment with our profesional doctors!',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24)
                  .copyWith(bottom: Sizes.p32),
              sliver: const SliverToBoxAdapter(
                child: UncompleteProfileNotice(hideWhenComplete: true),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24)
                  .copyWith(bottom: Sizes.p16),
              sliver: const SliverToBoxAdapter(
                child: _AppointmentListTitle(title: 'Active Appointments'),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: Sizes.p32),
              sliver: SliverToBoxAdapter(
                child: _Appointments(filter: AppointmentFilter.active),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24)
                  .copyWith(bottom: Sizes.p16),
              sliver: const SliverToBoxAdapter(
                child: _AppointmentListTitle(title: 'Recent Appointments'),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: Sizes.p32),
              sliver: SliverToBoxAdapter(
                child: _Appointments(filter: AppointmentFilter.completed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeText extends RearchConsumer {
  const _WelcomeText();

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final (name, placeholder) = use(fullName$);
    final (clinic, clinicPlaceholder) = use(clinicName$);

    return Skeletonizer(
      enabled: name == null || clinic == null,
      child: AutoSizeText(
        'Welcome to ${clinic ?? clinicPlaceholder} ${name ?? placeholder}!',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w600),
        minFontSize: 18,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _AppointmentListTitle extends StatelessWidget {
  // ignore: unused_element
  const _AppointmentListTitle({required this.title, this.completed = false});

  final String title;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        GestureDetector(
          onTap: () {
            // const AppointmentsRoute().push(context);
            StatefulNavigationShell.of(dashboard.currentContext!).goBranch(1);
          },
          child: Text(
            'See all',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

enum AppointmentFilter {
  active,
  completed,
}

class _Appointments extends RearchConsumer {
  const _Appointments({required this.filter});

  final AppointmentFilter filter;

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final items = use(appointments);
    final completed = use(completedAppointments);

    return SizedBox(
      height: 180,
      width: 400,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => AppointmentCard(
          appointment: filter == AppointmentFilter.completed
              ? completed[index]
              : items[index],
        ),
        separatorBuilder: (context, index) => gapW16,
        itemCount: filter == AppointmentFilter.completed
            ? completed.length
            : items.length,
      ),
    );
  }
}

List<Appointment> appointments(CapsuleHandle use) {
  return appointmentsSeed(n: 20)
      .where((a) => a.status != 'rejected' && a.status != 'completed')
      .toList();
}

List<Appointment> completedAppointments(CapsuleHandle use) {
  final items = use(appointments);
  return items.where((a) => a.status == 'completed').toList();
}
