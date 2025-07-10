import 'package:flutter_test/flutter_test.dart';
import 'package:jbh_ringtone/jbh_ringtone.dart';
import 'package:jbh_ringtone/jbh_ringtone_platform_interface.dart';
import 'package:jbh_ringtone/jbh_ringtone_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJbhRingtonePlatform with MockPlatformInterfaceMixin implements JbhRingtonePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<Map<String, dynamic>>> getRingtones() => Future.value([
    {'id': 1, 'title': 'Test Ringtone 1', 'uri': 'content://media/external/audio/media/1'},
    {'id': 2, 'title': 'Test Ringtone 2', 'uri': 'content://media/external/audio/media/2'},
  ]);
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
    expect(ringtones[0]['title'], 'Test Ringtone 1');
    expect(ringtones[1]['title'], 'Test Ringtone 2');
  });
}
