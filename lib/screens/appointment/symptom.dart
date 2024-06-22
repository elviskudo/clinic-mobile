import 'package:clinic/constants/sizes.dart';
import 'package:flutter/material.dart';

class AppointmentSymptomScreen extends StatelessWidget {
  const AppointmentSymptomScreen({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24),
        shrinkWrap: true,
        children: [
          Text(
            'Symptoms',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          gapH8,
          const Text(
            "Please pick only related symptoms and make sure it is aligned with your current health condition. Also don't forget to add additional information for the doctor to examine.",
          ),
          gapH16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                runSpacing: Sizes.p4,
                spacing: Sizes.p16,
                children: List.generate(
                  20,
                  (index) => Chip(
                    label: Text(
                      'Headache',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              gapH24,
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Symptom Description'),
                  hintText: 'Describe your symptom here...',
                ),
                maxLines: 5,
                maxLength: 250,
              ),
            ],
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
                  tabController.animateTo(3);
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
