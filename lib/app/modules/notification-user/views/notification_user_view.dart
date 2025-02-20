import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notification_user_controller.dart';

class NotificationUserView extends GetView<NotificationUserController> {
  const NotificationUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationUserView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NotificationUserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
