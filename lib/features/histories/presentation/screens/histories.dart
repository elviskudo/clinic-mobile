import 'package:flutter/material.dart';

import '../../../../widgets/photo_profile.dart';

class HistoriesScreen extends StatelessWidget {
  const HistoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PhotoProfile(),
      ),
      body: const Center(
        child: Text('Histories page'),
      ),
    );
  }
}
