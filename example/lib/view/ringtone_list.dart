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
  String? _currentlyPlayingUri;
  bool _isPlaying = false;

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
      ringtones = await ringtone.getAllRingtones();
      // alarmRingtones = await ringtone.getAlarmRingtones();
      // notificationRingtones = await ringtone.getNotificationRingtones();
      // ringtoneOnly = await ringtone.getRingtoneOnly();
      // allRingtones = await ringtone.getAllRingtones();
      //? You can also fetch ringtones by type
      // await ringtone.getRingtonesByType(RingtoneType.alarm);

      isLoading = false;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
  }

  Future<void> _playRingtone(JbhRingtoneModel ringtone) async {
    try {
      final JbhRingtone jbhRingtone = JbhRingtone();

      // Eğer başka bir ringtone çalıyorsa durdur
      if (_isPlaying) {
        await jbhRingtone.stopRingtone();
      }

      // Yeni ringtone'u çal
      await jbhRingtone.playRingtone(ringtone.uri);

      if (!mounted) return;

      setState(() {
        _currentlyPlayingUri = ringtone.uri;
        _isPlaying = true;
      });

      // 5 saniye sonra otomatik durdur
      // Future.delayed(const Duration(seconds: 5), () async {
      //   if (_currentlyPlayingUri == ringtone.uri) {
      //     await jbhRingtone.stopRingtone();
      //     if (!mounted) return;
      //     setState(() {
      //       _currentlyPlayingUri = null;
      //       _isPlaying = false;
      //     });
      //   }
      // });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Playing: ${ringtone.displayTitle}'), duration: const Duration(seconds: 2)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error playing ringtone: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _stopRingtone() async {
    try {
      final JbhRingtone jbhRingtone = JbhRingtone();
      await jbhRingtone.stopRingtone();

      if (!mounted) return;

      setState(() {
        _currentlyPlayingUri = null;
        _isPlaying = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stopped playing')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error stopping ringtone: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _showRingtoneDetails(JbhRingtoneModel ringtone) async {
    try {
      final JbhRingtone jbhRingtone = JbhRingtone();
      final info = await jbhRingtone.getRingtoneInfo(ringtone.uri);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ringtone Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Title', ringtone.title),
                _buildDetailRow('Display Title', ringtone.displayTitle),
                _buildDetailRow('File Name', ringtone.fileName),
                _buildDetailRow('URI', ringtone.uri),
                _buildDetailRow('URI Type', ringtone.uriType),
                _buildDetailRow('File Path', ringtone.filePath ?? 'N/A'),
                _buildDetailRow('File Size', ringtone.formattedFileSize),
                _buildDetailRow('Duration', ringtone.formattedDuration),
                _buildDetailRow('Type', ringtone.type.displayName),
                _buildDetailRow('Is Default', ringtone.isDefault ? 'Yes' : 'No'),
                const SizedBox(height: 16),
                const Text('Live Info:', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildDetailRow('Is Playing', info['isPlaying'] ? 'Yes' : 'No'),
                _buildDetailRow('Live Duration', '${info['duration']}ms'),
              ],
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting ringtone info: $e'), backgroundColor: Colors.red));
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('JBH Ringtone Example'),
        actions: [
          if (_isPlaying) IconButton(icon: const Icon(Icons.stop), onPressed: _stopRingtone, tooltip: 'Stop Playing'),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRingtones, tooltip: 'Refresh'),
        ],
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

    return Column(
      children: [
        // Statistics Card
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Total', _ringtones.length.toString(), Icons.music_note)),
                    Expanded(child: _buildStatCard('Alarms', alarmRingtones.length.toString(), Icons.alarm)),
                    Expanded(child: _buildStatCard('Notifications', notificationRingtones.length.toString(), Icons.notifications)),
                    Expanded(child: _buildStatCard('Ringtones', ringtoneOnly.length.toString(), Icons.phone)),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Ringtone List
        Expanded(
          child: ListView.builder(
            itemCount: _ringtones.length,
            itemBuilder: (context, index) {
              final ringtone = _ringtones[index];
              final isCurrentlyPlaying = _currentlyPlayingUri == ringtone.uri;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCurrentlyPlaying ? Colors.green : Colors.blue,
                    child: Icon(isCurrentlyPlaying ? Icons.play_arrow : Icons.music_note, color: Colors.white),
                  ),
                  title: Text(ringtone.displayTitle, style: TextStyle(fontWeight: isCurrentlyPlaying ? FontWeight.bold : FontWeight.normal)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ringtone.title != ringtone.displayTitle ? ringtone.title : '',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                      ),

                      Wrap(
                        spacing: 4,
                        children: [
                          Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                          Text(ringtone.formattedDuration, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          Icon(Icons.storage, size: 14, color: Colors.grey[600]),
                          Text(ringtone.formattedFileSize, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          if (ringtone.isDefault) ...[Icon(Icons.star, size: 14, color: Colors.amber[600]), Text('Default', style: TextStyle(fontSize: 12, color: Colors.amber[600]))],
                        ],
                      ),
                      Wrap(
                        spacing: 4,
                        children: [
                          Icon(Icons.category, size: 14, color: Colors.grey[600]),
                          Text(ringtone.type.displayName, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                          Icon(Icons.link, size: 14, color: Colors.grey[600]),
                          Text(ringtone.uriType, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(isCurrentlyPlaying ? Icons.stop : Icons.play_arrow, color: isCurrentlyPlaying ? Colors.red : Colors.green),
                        onPressed: () {
                          if (isCurrentlyPlaying) {
                            _stopRingtone();
                          } else {
                            _playRingtone(ringtone);
                          }
                        },
                        tooltip: isCurrentlyPlaying ? 'Stop' : 'Play',
                      ),
                      IconButton(icon: const Icon(Icons.info_outline), onPressed: () => _showRingtoneDetails(ringtone), tooltip: 'Details'),
                    ],
                  ),
                  onTap: () => _showRingtoneDetails(ringtone),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
