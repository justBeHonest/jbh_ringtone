import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'jbh_ringtone_platform_interface.dart';

/// An implementation of [JbhRingtonePlatform] that uses method channels.
class MethodChannelJbhRingtone extends JbhRingtonePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('jbh_ringtone');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<List<Map<String, dynamic>>> getRingtones() async {
    try {
      final String result = await methodChannel.invokeMethod('getRingtones');
      final List<dynamic> jsonList = json.decode(result);
      return jsonList.cast<Map<String, dynamic>>();
    } on PlatformException catch (e) {
      throw Exception('Failed to get ringtones: ${e.message}');
    }
  }
}
