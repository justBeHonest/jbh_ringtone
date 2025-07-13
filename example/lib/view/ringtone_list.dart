import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jbh_ringtone/jbh_ringtone.dart';
import 'package:jbh_ringtone/model/jbh_ringtone_model.dart';

class RingtoneListPage extends StatefulWidget {
  const RingtoneListPage({super.key});

  @override
  State<RingtoneListPage> createState() => _RingtoneListPageState();
}

class _RingtoneListPageState extends State<RingtoneListPage> {
  List<JbhRingtoneModel> _ringtones = [];
  List<JbhRingtoneModel> alarmRingtones = [];
  List<JbhRingtoneModel> notificationRingtones = [];
  List<JbhRingtoneModel> ringtoneOnly = [];
  List<JbhRingtoneModel> allRingtones = [];

  bool _isLoading = false;
  String? _error;

  List<JbhRingtoneModel> get ringtones => _ringtones;
  set ringtones(List<JbhRingtoneModel> value) {
    setState(() {
      _ringtones = value;
    });
  }

  String? get error => _error;
  set error(String? value) {
    setState(() {
      _error = value;
    });
  }

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRingtones();
  }

  Future<void> _loadRingtones() async {
    isLoading = true;
    error = null;
    try {
      final JbhRingtone ringtone = JbhRingtone();
      ringtones = await ringtone.getRingtones();
      alarmRingtones = await ringtone.getAlarmRingtones();
      notificationRingtones = await ringtone.getNotificationRingtones();
      ringtoneOnly = await ringtone.getRingtoneOnly();
      allRingtones = await ringtone.getAllRingtones();
      //? You can also fetch ringtones by type
      // await ringtone.getRingtonesByType(RingtoneType.alarm);

      isLoading = false;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('JBH Ringtone Example'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRingtones)],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Ringtones are loading...')]),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadRingtones, child: const Text('Try Again')),
          ],
        ),
      );
    }

    if (_ringtones.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Ringtone list is empty'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _ringtones.length,
      itemBuilder: (context, index) {
        final ringtone = _ringtones[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(ringtone.title),
            subtitle: Text(ringtone.uri),
            trailing: Text('ID: ${ringtone.id}'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected: ${ringtone.title}'), duration: const Duration(seconds: 2)));
            },
          ),
        );
      },
    );
  }
}
