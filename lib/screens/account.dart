import 'package:clinic/data/queries/profile.dart';
import 'package:clinic/widgets/photo_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountScreen extends HookWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = useProfile();

    return Scaffold(
      appBar: AppBar(
        title: PhotoProfile(url: profile.data?.imageUrl),
      ),
      body: const Center(
        child: Text('Profile page'),
      ),
    );
  }
}
