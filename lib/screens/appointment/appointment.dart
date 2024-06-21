import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'capture.dart';
import 'code.dart';
import 'schedule.dart';
import 'symptom.dart';

class AppointmentScreen extends HookWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = useTabController(initialLength: 4);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go('/home');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointment'),
          bottom: TabBar(
            controller: tab,
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            onTap: (index) {
              if (index == tab.index) return;
              tab.animateTo(
                index,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              );
            },
            tabs: const [
              Tab(text: 'Schedule'),
              Tab(text: 'Code'),
              Tab(text: 'Symptom'),
              Tab(text: 'Capture'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: tab,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              AppointmentScheduleScreen(),
              AppointmentCodeScreen(),
              AppointmentSymptomScreen(),
              AppointmentCaptureScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
