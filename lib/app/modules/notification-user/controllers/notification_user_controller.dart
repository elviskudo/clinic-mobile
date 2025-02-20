import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationUserController extends GetxController {
  final _supabase = Supabase.instance.client;

  // Mengirim notifikasi ke user berdasarkan role
  Future<bool> sendNotificationToRole({
    required String role,
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    try {
      // Dapatkan semua user dengan role yang ditentukan
      final users = await _supabase
          .from('users')
          .select('id, notification_token')
          .eq('role', role);

      // Kirim notifikasi ke setiap user
      for (var user in users) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
            channelKey: 'doctor_channel',
            title: title,
            body: body,
            notificationLayout: NotificationLayout.Default,
            payload: payload,
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'VIEW',
              label: 'Lihat',
            ),
          ],
        );
      }
      return true;
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }

  // Mengirim notifikasi ke user spesifik
  Future<bool> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    try {
      // Dapatkan user dengan ID yang ditentukan
      final user = await _supabase
          .from('users')
          .select('notification_token')
          .eq('id', userId)
          .single();

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'doctor_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          payload: payload,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'VIEW',
            label: 'Lihat',
          ),
        ],
      );
      return true;
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }
}
