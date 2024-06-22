import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/constants/sizes.dart';
import 'package:clinic/constants/theme.dart';
import 'package:flutter/material.dart';

class AppointmentCodeScreen extends StatelessWidget {
  const AppointmentCodeScreen({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(Sizes.p24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    MaterialTheme.lightMediumContrastScheme().primaryFixed,
                    MaterialTheme.lightScheme().primary,
                  ],
                  stops: const [0.05, 0.7],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'JE083 - John Doe',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: MaterialTheme.lightScheme().onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    gapH8,
                    Text(
                      'Save his barcode and show it to the staff',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: MaterialTheme.lightScheme().onPrimary,
                          ),
                    ),
                    gapH24,
                    CachedNetworkImage(
                      imageUrl:
                          'https://cdn.pixabay.com/photo/2023/02/28/01/51/qr-code-7819654_1280.jpg',
                      width: 180,
                      height: 180,
                      filterQuality: FilterQuality.high,
                    )
                  ],
                ),
              ),
            ),
            gapH16,
            Text(
              'Download QR Code',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p24,
                vertical: Sizes.p16,
              ),
              child: FilledButton(
                onPressed: () {
                  tabController.animateTo(2);
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
