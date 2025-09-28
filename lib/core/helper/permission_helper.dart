import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestPermissions() async {
    await Future.delayed(const Duration(milliseconds: 100));
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool granted = statuses.values.every((status) => status.isGranted);
    return granted;
  }
}
