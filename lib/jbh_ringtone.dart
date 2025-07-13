import 'jbh_ringtone_platform_interface.dart';
import 'model/jbh_ringtone_model.dart';

// Export the model and enum for public use
export 'model/jbh_ringtone_model.dart';

class JbhRingtone {
  /// Get platform version
  Future<String?> getPlatformVersion() {
    return JbhRingtonePlatform.instance.getPlatformVersion();
  }

  /// Get all ringtones (legacy method for backward compatibility)
  Future<List<JbhRingtoneModel>> getRingtones() {
    return JbhRingtonePlatform.instance.getRingtones();
  }

  /// Get ringtones by specific type
  Future<List<JbhRingtoneModel>> getRingtonesByType(RingtoneType type) {
    return JbhRingtonePlatform.instance.getRingtonesByType(type);
  }

  /// Get ringtones by multiple types
  Future<List<JbhRingtoneModel>> getRingtonesByTypes(List<RingtoneType> types) {
    return JbhRingtonePlatform.instance.getRingtonesByTypes(types);
  }

  /// Get ringtones with custom filter options
  Future<List<JbhRingtoneModel>> getRingtonesWithFilter({bool includeRingtone = false, bool includeNotification = false, bool includeAlarm = false}) {
    return JbhRingtonePlatform.instance.getRingtonesWithFilter(includeRingtone: includeRingtone, includeNotification: includeNotification, includeAlarm: includeAlarm);
  }

  /// Play a ringtone by URI
  Future<String> playRingtone(String uri) {
    return JbhRingtonePlatform.instance.playRingtone(uri);
  }

  /// Stop currently playing ringtone
  Future<String> stopRingtone() {
    return JbhRingtonePlatform.instance.stopRingtone();
  }

  /// Get information about a specific ringtone
  Future<Map<String, dynamic>> getRingtoneInfo(String uri) {
    return JbhRingtonePlatform.instance.getRingtoneInfo(uri);
  }

  /// Get detailed information about a specific ringtone (enhanced version)
  Future<Map<String, dynamic>> getRingtoneDetails(String uri) {
    return JbhRingtonePlatform.instance.getRingtoneDetails(uri);
  }

  // Convenience methods for specific ringtone types
  Future<List<JbhRingtoneModel>> getRingtoneOnly() {
    return getRingtonesByType(RingtoneType.ringtone);
  }

  Future<List<JbhRingtoneModel>> getNotificationRingtones() {
    return getRingtonesByType(RingtoneType.notification);
  }

  Future<List<JbhRingtoneModel>> getAlarmRingtones() {
    return getRingtonesByType(RingtoneType.alarm);
  }

  Future<List<JbhRingtoneModel>> getAllRingtones() {
    return getRingtonesByType(RingtoneType.all);
  }
}
