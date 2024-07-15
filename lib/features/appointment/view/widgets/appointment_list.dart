import 'package:clinic/utils/sizes.dart';
import 'package:flutter/material.dart';

enum AppointmentFilter { onprogress, completed }

class AppointmentList extends StatelessWidget {
  const AppointmentList({super.key, required this.filter});

  final AppointmentFilter filter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              IgnorePointer(
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                  ),
                ),
              ),
              ListView.separated(
                itemBuilder: (context, index) => const Card(
                  margin: EdgeInsets.all(0),
                  child: Column(),
                ),
                separatorBuilder: (context, index) => gapW16,
                itemCount: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
