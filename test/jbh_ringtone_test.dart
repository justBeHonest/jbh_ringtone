import 'package:flutter_test/flutter_test.dart';
import 'package:jbh_ringtone/jbh_ringtone.dart';
import 'package:jbh_ringtone/jbh_ringtone_platform_interface.dart';
import 'package:jbh_ringtone/jbh_ringtone_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJbhRingtonePlatform with MockPlatformInterfaceMixin implements JbhRingtonePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<JbhRingtoneModel>> getRingtones() => Future.value([
  ]);

  @override
  Future<List<JbhRingtoneModel>> getRingtonesByType(RingtoneType type) {
    // TODO: implement getRingtonesByType
    throw UnimplementedError();
  }

  @override
  Future<List<JbhRingtoneModel>> getRingtonesByTypes(List<RingtoneType> types) {
    // TODO: implement getRingtonesByTypes
    throw UnimplementedError();
  }

  @override
  Future<List<JbhRingtoneModel>> getRingtonesWithFilter({bool includeRingtone = false, bool includeNotification = false, bool includeAlarm = false}) {
    // TODO: implement getRingtonesWithFilter
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getRingtoneDetails(String uri) {
    // TODO: implement getRingtoneDetails
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getRingtoneInfo(String uri) {
    // TODO: implement getRingtoneInfo
    throw UnimplementedError();
  }

  @override
  Future<String> playRingtone(String uri) {
    // TODO: implement playRingtone
    throw UnimplementedError();
  }

  @override
  Future<String> stopRingtone() {
    // TODO: implement stopRingtone
    throw UnimplementedError();
  }
}

void main() {
  final JbhRingtonePlatform initialPlatform = JbhRingtonePlatform.instance;

  test('$MethodChannelJbhRingtone is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJbhRingtone>());
  });

  test('getPlatformVersion', () async {
    JbhRingtone jbhRingtonePlugin = JbhRingtone();
    MockJbhRingtonePlatform fakePlatform = MockJbhRingtonePlatform();
    JbhRingtonePlatform.instance = fakePlatform;

    expect(await jbhRingtonePlugin.getPlatformVersion(), '42');
  });

  test('getRingtones', () async {
    JbhRingtone jbhRingtonePlugin = JbhRingtone();
    MockJbhRingtonePlatform fakePlatform = MockJbhRingtonePlatform();
    JbhRingtonePlatform.instance = fakePlatform;

    final ringtones = await jbhRingtonePlugin.getRingtones();
    expect(ringtones, isA<List<Map<String, dynamic>>>());
    expect(ringtones.length, 2);
  });
}
