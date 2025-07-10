import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jbh_ringtone_method_channel.dart';

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

  Future<List<Map<String, dynamic>>> getRingtones() {
    throw UnimplementedError('getRingtones() has not been implemented.');
  }
}
