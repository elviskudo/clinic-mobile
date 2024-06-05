import 'package:flutter/material.dart';

import '../../../../widgets/photo_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PhotoProfile(),
      ),
      body: const Center(
        child: Text('Profile page'),
      ),
    );
  }
}
