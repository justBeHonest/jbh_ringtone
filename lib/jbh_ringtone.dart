import 'jbh_ringtone_platform_interface.dart';

class JbhRingtone {
  Future<String?> getPlatformVersion() {
    return JbhRingtonePlatform.instance.getPlatformVersion();
  }

  Future<List<Map<String, dynamic>>> getRingtones() {
    return JbhRingtonePlatform.instance.getRingtones();
  }
}
