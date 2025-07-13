import 'package:flutter/material.dart';
import 'package:jbh_ringtone/jbh_ringtone.dart';
import 'package:jbh_ringtone_example/view/ringtone_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JBH Ringtone Example',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const RingtoneListPage(),
    );
  }
}
