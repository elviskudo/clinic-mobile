import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';

class AppointmentsScreen extends RearchConsumer {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    return const Scaffold(
      body: Center(
        child: Text('Appointments Page'),
      ),
    );
  }
}
