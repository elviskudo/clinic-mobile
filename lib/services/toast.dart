import 'package:native_toast/native_toast.dart';

final toaster = NativeToast();

void toast(String message) async {
  await toaster.makeText(message: message);
}
