import 'package:auto_size_text/auto_size_text.dart';
import 'package:clinic/features/appointment/appointment.dart';
import 'package:clinic/features/profile/profile.dart';
import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppointmentFloatingActionButton(),
      body: SafeArea(
        child: ListView(
          primary: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: RearchBuilder(
                builder: (context, use) {
                  final (name, placeholder) = use(fullName$);
                  return Skeletonizer(
                    enabled: name == null,
                    child: AutoSizeText(
                      'Welcome to Mayou Clinic ${name ?? placeholder}!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                      minFontSize: 18,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
            gapH16,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: Text(
                'How\'s your heath? Let\'s start by making appointment with our profesional doctors!',
              ),
            ),
            gapH32,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: UncompleteProfileNotice(hideWhenComplete: true),
            ),
            gapH32,
            const AppointmentListTitle(title: 'Active Appointments'),
            gapH16,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: AppointmentList(
                filter: AppointmentFilter.onprogress,
              ),
            ),
            gapH32,
            const AppointmentListTitle(title: 'Active Appointments'),
            gapH16,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: AppointmentList(
                filter: AppointmentFilter.completed,
              ),
            ),
            gapH32,
            const AppointmentListTitle(title: 'Recent Appointments'),
            gapH16,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.p24),
              child: AppointmentList(
                filter: AppointmentFilter.completed,
              ),
            ),
            gapH32,
          ],
        ),
      ),
    );
  }
}
