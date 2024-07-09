import 'package:clinic/widgets/dashboard_header.dart';
import 'package:flutter/material.dart';

class HistoriesPage extends StatelessWidget {
  const HistoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DashboardHeader(),
    );
  }
}
