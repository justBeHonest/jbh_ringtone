import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jbh_ringtone/jbh_ringtone_method_channel.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelJbhRingtone platform = MethodChannelJbhRingtone();
  const MethodChannel channel = MethodChannel('jbh_ringtone');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '42';
        case 'getRingtones':
          return json.encode([
            {'id': 1, 'title': 'Test Ringtone 1', 'uri': 'content://media/external/audio/media/1'},
            {'id': 2, 'title': 'Test Ringtone 2', 'uri': 'content://media/external/audio/media/2'},
          ]);
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('getRingtones', () async {
    final ringtones = await platform.getRingtones();
    expect(ringtones, isA<List<Map<String, dynamic>>>());
    expect(ringtones.length, 2);
    expect(ringtones[0]['title'], 'Test Ringtone 1');
    expect(ringtones[1]['title'], 'Test Ringtone 2');
  });
}
