import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clinic_ai/app/modules/Theme/controllers/theme_controller.dart';
import 'package:clinic_ai/app/translations/app_translations.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/modules/(home)/(appoinment)/appointment/controllers/appointment_controller.dart';
import 'app/modules/(home)/(appoinment)/barcodeAppointment/controllers/barcode_appointment_controller.dart';
import 'app/modules/(home)/(appoinment)/captureAppointment/controllers/capture_appointment_controller.dart';
import 'app/modules/(home)/(appoinment)/scheduleAppointment/controllers/schedule_appointment_controller.dart';
import 'app/modules/(home)/(appoinment)/symptomAppointment/controllers/symptom_appointment_controller.dart';

void requestNotificationPermission() async {
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}

Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  // Handle different routes based on channel key
  switch (receivedAction.channelKey) {
    case 'doctor_channel':
      Get.toNamed(Routes.QR_SCANNER_SCREEN);
      break;
    case 'transaction_service':
      // If you need to pass transaction data
      final payload =
          receivedAction.payload; // Get any additional data if needed
      Get.toNamed(Routes.QR_SCANNER_SCREEN);
      break;
    default:
      Get.toNamed(Routes.QR_SCANNER_SCREEN); // Default route
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!, anonKey: dotenv.env['SUPABASE_KEY']!);
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'doctor_channel',
          channelName: 'Doctor channel',
          channelDescription: 'Notifications from User',
          defaultColor: Colors.blue,
          importance: NotificationImportance.High,
        ),
      ],
    );
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );

    EmailOTP.config(
      appName: 'Clinic AI',
      otpType: OTPType.numeric,
      expiry: 120000,
      emailTheme: EmailTheme.v1,
      appEmail: 'clinic.ai@gmail.com',
      otpLength: 6,
    );

    print('Database connection successful!');

    // Inisialisasi controller di sini
    Get.put(AppointmentController());
    Get.put(ScheduleAppointmentController());
    Get.put(BarcodeAppointmentController());
    Get.put(SymptomAppointmentController());
    Get.put(CaptureAppointmentController());
    Get.put(ThemeController());

    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        translations: AppTranslations(),
        locale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        // theme: lightTheme,
        // darkTheme: darkTheme,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeController.to.themeMode,
      ),
    );
  } catch (e) {
    print('Database connection failed: $e');
    // Tampilkan dialog error atau handling sesuai kebutuhan
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Koneksi database gagal',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: GoogleFonts.poppins(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Implementasi retry logic di sini
                    main();
                  },
                  child: Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
