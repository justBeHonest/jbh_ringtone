import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jbh_ringtone_method_channel.dart';
import 'model/jbh_ringtone_model.dart';

abstract class JbhRingtonePlatform extends PlatformInterface {
  /// Constructs a JbhRingtonePlatform.
  JbhRingtonePlatform() : super(token: _token);

  static final Object _token = Object();

  static JbhRingtonePlatform _instance = MethodChannelJbhRingtone();

  /// The default instance of [JbhRingtonePlatform] to use.
  ///
  /// Defaults to [MethodChannelJbhRingtone].
  static JbhRingtonePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JbhRingtonePlatform] when
  /// they register themselves.
  static set instance(JbhRingtonePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Get all ringtones (legacy method for backward compatibility)
  Future<List<JbhRingtoneModel>> getRingtones() {
    throw UnimplementedError('getRingtones() has not been implemented.');
  }

  /// Get ringtones with specific type
  Future<List<JbhRingtoneModel>> getRingtonesByType(RingtoneType type) {
    throw UnimplementedError('getRingtonesByType() has not been implemented.');
  }

  /// Get ringtones with multiple types
  Future<List<JbhRingtoneModel>> getRingtonesByTypes(List<RingtoneType> types) {
    throw UnimplementedError('getRingtonesByTypes() has not been implemented.');
  }

  /// Get ringtones with custom filter options
  Future<List<JbhRingtoneModel>> getRingtonesWithFilter({bool includeRingtone = false, bool includeNotification = false, bool includeAlarm = false}) {
    throw UnimplementedError('getRingtonesWithFilter() has not been implemented.');
  }
}
