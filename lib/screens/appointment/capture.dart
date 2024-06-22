import 'package:clinic/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppointmentCaptureScreen extends StatelessWidget {
  const AppointmentCaptureScreen({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(Sizes.p24),
        shrinkWrap: true,
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PhosphorIcon(
                        PhosphorIconsFill.info,
                        color:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                      gapW8,
                      Expanded(
                        child: Text(
                          'Take image of your face, teeth, or eyes!',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  gapH16,
                  Text(
                    '• Take pictures using HD resolution\n• Make sure to point the camera at the problem area\n• The captured image must be clear and not blurry.',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ),
          gapH24,
          SizedBox(
            height: 380,
            child: Card(
              borderOnForeground: true,
              semanticContainer: true,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
              child: Center(
                child: PhosphorIcon(
                  PhosphorIconsDuotone.imageSquare,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
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
                  tabController.animateTo(4);
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
