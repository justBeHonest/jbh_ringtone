import 'package:flutter/material.dart';
import 'package:jbh_ringtone/jbh_ringtone.dart';

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

class RingtoneListPage extends StatefulWidget {
  const RingtoneListPage({super.key});

  @override
  State<RingtoneListPage> createState() => _RingtoneListPageState();
}

class _RingtoneListPageState extends State<RingtoneListPage> {
  List<Map<String, dynamic>> _ringtones = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRingtones();
  }

  Future<void> _loadRingtones() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final JbhRingtone ringtone = JbhRingtone();
      final ringtones = await ringtone.getRingtones();

      setState(() {
        _ringtones = ringtones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Zil sesleri yükleniyor...')]),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Hata: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadRingtones, child: const Text('Tekrar Dene')),
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
            Text('Zil sesi bulunamadı'),
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
            title: Text(ringtone['title'] ?? 'Bilinmeyen'),
            subtitle: Text(ringtone['uri'] ?? ''),
            trailing: Text('ID: ${ringtone['id']}'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seçilen: ${ringtone['title']}'), duration: const Duration(seconds: 2)));
            },
          ),
        );
      },
    );
  }
}
