import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'jbh_ringtone_platform_interface.dart';
import 'model/jbh_ringtone_model.dart';

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
  Future<List<JbhRingtoneModel>> getRingtones() async {
    try {
      final String result = await methodChannel.invokeMethod('getRingtones');
      final List<dynamic> jsonList = json.decode(result);
      return jsonList.map((json) => JbhRingtoneModel.fromMap(json)).toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get ringtones: ${e.message}');
    }
  }

  @override
  Future<List<JbhRingtoneModel>> getRingtonesByType(RingtoneType type) async {
    try {
      final String result = await methodChannel.invokeMethod('getRingtonesByType', {'type': type.value});
      final List<dynamic> jsonList = json.decode(result);
      return jsonList.map((json) => JbhRingtoneModel.fromMap(json)).toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get ringtones by type: ${e.message}');
    }
  }

  @override
  Future<List<JbhRingtoneModel>> getRingtonesByTypes(List<RingtoneType> types) async {
    try {
      final String result = await methodChannel.invokeMethod('getRingtonesByTypes', {'types': types.map((type) => type.value).toList()});
      final List<dynamic> jsonList = json.decode(result);
      return jsonList.map((json) => JbhRingtoneModel.fromMap(json)).toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get ringtones by types: ${e.message}');
    }
  }

  @override
  Future<List<JbhRingtoneModel>> getRingtonesWithFilter({bool includeRingtone = false, bool includeNotification = false, bool includeAlarm = false}) async {
    try {
      final String result = await methodChannel.invokeMethod('getRingtonesWithFilter', {'includeRingtone': includeRingtone, 'includeNotification': includeNotification, 'includeAlarm': includeAlarm});
      final List<dynamic> jsonList = json.decode(result);
      return jsonList.map((json) => JbhRingtoneModel.fromMap(json)).toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get ringtones with filter: ${e.message}');
    }
  }

  @override
  Future<String> playRingtone(String uri) async {
    try {
      final String result = await methodChannel.invokeMethod('playRingtone', {'uri': uri});
      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to play ringtone: ${e.message}');
    }
  }

  @override
  Future<String> stopRingtone() async {
    try {
      final String result = await methodChannel.invokeMethod('stopRingtone');
      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to stop ringtone: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getRingtoneInfo(String uri) async {
    try {
      final String result = await methodChannel.invokeMethod('getRingtoneInfo', {'uri': uri});
      final Map<String, dynamic> jsonMap = json.decode(result);
      return jsonMap;
    } on PlatformException catch (e) {
      throw Exception('Failed to get ringtone info: ${e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getRingtoneDetails(String uri) async {
    try {
      final String result = await methodChannel.invokeMethod('getRingtoneDetails', {'uri': uri});
      final Map<String, dynamic> jsonMap = json.decode(result);
      return jsonMap;
    } on PlatformException catch (e) {
      throw Exception('Failed to get ringtone details: ${e.message}');
    }
  }
}
