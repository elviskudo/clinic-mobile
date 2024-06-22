import 'package:clinic/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppointmentScheduleScreen extends StatelessWidget {
  const AppointmentScheduleScreen({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24),
        shrinkWrap: true,
        children: [
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  items: const [],
                  onChanged: (val) {},
                  decoration: const InputDecoration(
                    label: Text('Poly'),
                    hintText: 'Select poly...',
                  ),
                ),
                gapH16,
                DropdownButtonFormField(
                  items: const [],
                  onChanged: (val) {},
                  decoration: const InputDecoration(
                    label: Text('Doctor'),
                    hintText: 'Select Doctor...',
                  ),
                ),
                gapH16,
                DropdownButtonFormField(
                  items: const [],
                  onChanged: (val) {},
                  decoration: const InputDecoration(
                    label: Text('Time'),
                    hintText: 'Select time...',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p24,
                vertical: Sizes.p8,
              ),
              child: FilledButton(
                onPressed: () {
                  tabController.animateTo(1);
                },
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
