# jbh_ringtone

[![pub package](https://img.shields.io/pub/v/jbh_ringtone.svg)](https://pub.dev/packages/jbh_ringtone)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin that provides easy access to device ringtones with advanced features. **Currently in active development** - this plugin allows you to retrieve the list of available ringtones with their IDs, titles, URIs, types, and even play them directly.

## 🚧 Current Status

This plugin is **actively being developed** and currently supports:
- ✅ **Android**: Full support for retrieving ringtones with different types, playing audio, and detailed information
- 🚧 **iOS**: Coming soon (in development)
- 📋 **Future plans**: Enhanced audio controls, selection features, and cross-platform functionality

## Features

### Currently Available
- 📱 **Android support**: Works on Android devices (API level 21+)
- 🎵 **Ringtone listing**: Retrieves available ringtones with comprehensive information
- 🎧 **Audio playback**: Play and stop ringtones directly from the plugin
- 🎯 **Type-specific methods**: Get ringtones by type (ringtone, notification, alarm)
- 🔍 **Flexible filtering**: Custom filter options for multiple ringtone types
- 📦 **Enhanced models**: Rich `JbhRingtoneModel` with file size, duration, and metadata
- ⚡ **Performance optimized**: Fast loading with lazy loading for detailed information
- 🛡️ **Error handling**: Robust error handling with meaningful error messages
- 📦 **No dependencies**: Lightweight with minimal external dependencies
- 🔄 **Real-time info**: Get live information about currently playing ringtones

### Coming Soon
- 🍎 **iOS support**: Full cross-platform compatibility
- 🎯 **Enhanced selection**: Better ringtone management features
- 📝 **Improved titles**: Better ringtone name resolution
- 🎛️ **Volume control**: Adjust playback volume
- ⏱️ **Playback controls**: Pause, resume, and seek functionality

## Getting Started

### Installation

Add `jbh_ringtone` to your `pubspec.yaml` file:

```yaml
dependencies:
  jbh_ringtone: ^1.0.1
```

Then run:

```bash
flutter pub get
```

### Platform Setup

#### Android

No additional setup required! The plugin automatically handles all necessary permissions and configurations.

#### iOS

**Note**: iOS support is currently in development and will be available in future updates.

## Usage

### Basic Usage with Enhanced API

```dart
import 'package:jbh_ringtone/jbh_ringtone.dart';

void main() async {
  // Create an instance of JbhRingtone
  JbhRingtone ringtone = JbhRingtone();
  
  try {
    // Get all ringtones (enhanced typed API)
    List<JbhRingtoneModel> allRingtones = await ringtone.getRingtones();
    
    print('Found ${allRingtones.length} ringtones');
    
    // Display each ringtone with enhanced information
    for (var ringtone in allRingtones) {
      print('Title: ${ringtone.title}');
      print('Display Title: ${ringtone.displayTitle}');
      print('File Name: ${ringtone.fileName}');
      print('ID: ${ringtone.id}');
      print('URI: ${ringtone.uri}');
      print('Type: ${ringtone.type.displayName}');
      print('Duration: ${ringtone.formattedDuration}');
      print('File Size: ${ringtone.formattedFileSize}');
      print('Is Default: ${ringtone.isDefault}');
      print('---');
    }
  } catch (e) {
    print('Error: $e');
  }
}
```

### Audio Playback

```dart
// Play a ringtone
await ringtone.playRingtone(ringtoneModel.uri);

// Stop currently playing ringtone
await ringtone.stopRingtone();

// Get information about a specific ringtone
Map<String, dynamic> info = await ringtone.getRingtoneInfo(ringtoneModel.uri);
print('Is Playing: ${info['isPlaying']}');
print('Duration: ${info['duration']}ms');
```

### Enhanced Ringtone Information

```dart
// Get detailed information about a specific ringtone
Map<String, dynamic> details = await ringtone.getRingtoneDetails(ringtoneModel.uri);
print('Enhanced Title: ${details['title']}');
print('Display Title: ${details['displayTitle']}');
print('File Path: ${details['filePath']}');
print('File Size: ${details['fileSize']} bytes');
print('Duration: ${details['duration']}ms');
print('Is Default: ${details['isDefault']}');
```

### Type-Specific Methods

```dart
// Get only phone ringtones
List<JbhRingtoneModel> phoneRingtones = await ringtone.getRingtoneOnly();

// Get notification sounds
List<JbhRingtoneModel> notificationSounds = await ringtone.getNotificationRingtones();

// Get alarm sounds
List<JbhRingtoneModel> alarmSounds = await ringtone.getAlarmRingtones();

// Get all types
List<JbhRingtoneModel> allSounds = await ringtone.getAllRingtones();
```

### Advanced Filtering

```dart
// Get ringtones with custom filter
List<JbhRingtoneModel> customRingtones = await ringtone.getRingtonesWithFilter(
  includeRingtone: true,
  includeNotification: true,
  includeAlarm: false,
);

// Get by specific type
List<JbhRingtoneModel> ringtones = await ringtone.getRingtonesByType(RingtoneType.ringtone);

// Get by multiple types
List<JbhRingtoneModel> mixedRingtones = await ringtone.getRingtonesByTypes([
  RingtoneType.ringtone,
  RingtoneType.notification,
]);
```

### Advanced Usage with UI and Audio Controls

```dart
import 'package:flutter/material.dart';
import 'package:jbh_ringtone/jbh_ringtone.dart';

class RingtoneListPage extends StatefulWidget {
  @override
  _RingtoneListPageState createState() => _RingtoneListPageState();
}

class _RingtoneListPageState extends State<RingtoneListPage> {
  List<JbhRingtoneModel> _ringtones = [];
  bool _isLoading = false;
  String? _error;
  String? _currentlyPlayingUri;
  bool _isPlaying = false;
  RingtoneType _selectedType = RingtoneType.ringtone;

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
      final ringtones = await ringtone.getRingtonesByType(_selectedType);
      
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

  Future<void> _playRingtone(JbhRingtoneModel ringtone) async {
    try {
      final JbhRingtone jbhRingtone = JbhRingtone();
      
      // Stop previous ringtone if playing
      if (_isPlaying) {
        await jbhRingtone.stopRingtone();
      }
      
      // Play new ringtone
      await jbhRingtone.playRingtone(ringtone.uri);
      
      setState(() {
        _currentlyPlayingUri = ringtone.uri;
        _isPlaying = true;
      });
      
      // Auto-stop after 5 seconds
      Future.delayed(Duration(seconds: 5), () async {
        if (_currentlyPlayingUri == ringtone.uri) {
          await jbhRingtone.stopRingtone();
          setState(() {
            _currentlyPlayingUri = null;
            _isPlaying = false;
          });
        }
      });
    } catch (e) {
      print('Error playing ringtone: $e');
    }
  }

  Future<void> _stopRingtone() async {
    try {
      final JbhRingtone jbhRingtone = JbhRingtone();
      await jbhRingtone.stopRingtone();
      
      setState(() {
        _currentlyPlayingUri = null;
        _isPlaying = false;
      });
    } catch (e) {
      print('Error stopping ringtone: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Ringtones'),
        actions: [
          if (_isPlaying)
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: _stopRingtone,
              tooltip: 'Stop Playing',
            ),
          PopupMenuButton<RingtoneType>(
            onSelected: (RingtoneType type) {
              setState(() {
                _selectedType = type;
              });
              _loadRingtones();
            },
            itemBuilder: (BuildContext context) => RingtoneType.values.map((RingtoneType type) {
              return PopupMenuItem<RingtoneType>(
                value: type,
                child: Text(type.displayName),
              );
            }).toList(),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView.builder(
                  itemCount: _ringtones.length,
                  itemBuilder: (context, index) {
                    final ringtone = _ringtones[index];
                    final isCurrentlyPlaying = _currentlyPlayingUri == ringtone.uri;
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCurrentlyPlaying ? Colors.green : Colors.blue,
                        child: Icon(
                          isCurrentlyPlaying ? Icons.play_arrow : Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        ringtone.displayTitle,
                        style: TextStyle(
                          fontWeight: isCurrentlyPlaying ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Duration: ${ringtone.formattedDuration}'),
                          Text('Size: ${ringtone.formattedFileSize}'),
                          if (ringtone.isDefault)
                            Text('Default', style: TextStyle(color: Colors.amber)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isCurrentlyPlaying ? Icons.stop : Icons.play_arrow,
                              color: isCurrentlyPlaying ? Colors.red : Colors.green,
                            ),
                            onPressed: () {
                              if (isCurrentlyPlaying) {
                                _stopRingtone();
                              } else {
                                _playRingtone(ringtone);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
```

## API Reference

### JbhRingtone Class

The main class for interacting with device ringtones.

#### Methods

##### `getRingtones()` (Legacy)

Retrieves all available ringtones from the device (legacy method for backward compatibility).

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `getRingtonesByType(RingtoneType type)`

Retrieves ringtones of a specific type.

**Parameters:**
- `type`: The type of ringtones to retrieve (RingtoneType.ringtone, RingtoneType.notification, RingtoneType.alarm, RingtoneType.all)

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `getRingtonesByTypes(List<RingtoneType> types)`

Retrieves ringtones of multiple types.

**Parameters:**
- `types`: List of ringtone types to retrieve

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `getRingtonesWithFilter({bool includeRingtone, bool includeNotification, bool includeAlarm})`

Retrieves ringtones with custom filter options.

**Parameters:**
- `includeRingtone`: Whether to include phone ringtones (default: false)
- `includeNotification`: Whether to include notification sounds (default: false)
- `includeAlarm`: Whether to include alarm sounds (default: false)

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `playRingtone(String uri)`

Plays a ringtone by its URI.

**Parameters:**
- `uri`: The URI of the ringtone to play

**Returns:** `Future<String>` - Success message

##### `stopRingtone()`

Stops the currently playing ringtone.

**Returns:** `Future<String>` - Success message

##### `getRingtoneInfo(String uri)`

Gets basic information about a specific ringtone.

**Parameters:**
- `uri`: The URI of the ringtone

**Returns:** `Future<Map<String, dynamic>>` - Basic ringtone information

##### `getRingtoneDetails(String uri)`

Gets detailed information about a specific ringtone (enhanced version).

**Parameters:**
- `uri`: The URI of the ringtone

**Returns:** `Future<Map<String, dynamic>>` - Detailed ringtone information

#### Convenience Methods

##### `getRingtoneOnly()`

Gets only phone ringtones.

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `getNotificationRingtones()`

Gets notification sounds.

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `getAlarmRingtones()`

Gets alarm sounds.

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `getAllRingtones()`

Gets all types of sounds.

**Returns:** `Future<List<JbhRingtoneModel>>`

##### `getPlatformVersion()`

Gets the current platform version.

**Returns:** `Future<String?>`

### JbhRingtoneModel Class

Represents a single ringtone with comprehensive properties.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | `int` | Unique identifier for the ringtone |
| `title` | `String` | Human-readable name of the ringtone |
| `displayTitle` | `String` | User-friendly display title (shortened if needed) |
| `fileName` | `String` | Original file name of the ringtone |
| `uri` | `String` | Content URI for accessing the ringtone file |
| `uriType` | `String` | Type of URI (content, file, unknown) |
| `filePath` | `String?` | File path on device (null for lazy loading) |
| `fileSize` | `int` | File size in bytes (0 for lazy loading) |
| `duration` | `int` | Duration in milliseconds (0 for lazy loading) |
| `type` | `RingtoneType` | Type of the ringtone (ringtone, notification, alarm, all) |
| `isDefault` | `bool` | Whether this is a default ringtone (false for lazy loading) |

#### Computed Properties

| Property | Type | Description |
|----------|------|-------------|
| `formattedDuration` | `String` | Duration formatted as "M:SS" |
| `formattedFileSize` | `String` | File size formatted as "X.X MB/KB" |

#### Methods

##### `fromMap(Map<String, dynamic> map)`

Creates a JbhRingtoneModel from a map.

##### `toMap()`

Converts the model to a map.

##### `toString()`

Returns a string representation with key information.

##### `operator ==(Object other)`

Compares two JbhRingtoneModel instances for equality.

##### `hashCode`

Returns the hash code for the model.

### RingtoneType Enum

Enum representing different types of ringtones.

#### Values

| Value | Display Name | Description |
|-------|--------------|-------------|
| `RingtoneType.ringtone` | "Ringtone" | Phone ringtone sounds |
| `RingtoneType.notification` | "Notification" | Notification sounds |
| `RingtoneType.alarm` | "Alarm" | Alarm sounds |
| `RingtoneType.all` | "All" | All types of sounds |

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `value` | `int` | Integer value used by Android RingtoneManager |
| `displayName` | `String` | Human-readable name |

## Error Handling

The plugin provides comprehensive error handling:

```dart
try {
  List<JbhRingtoneModel> ringtones = await ringtone.getRingtonesByType(RingtoneType.ringtone);
  // Handle success
} catch (e) {
  if (e.toString().contains('RINGTONE_ERROR')) {
    // Handle ringtone-specific errors
    print('Failed to access ringtones: $e');
  } else if (e.toString().contains('PLAY_ERROR')) {
    // Handle playback errors
    print('Failed to play ringtone: $e');
  } else if (e.toString().contains('STOP_ERROR')) {
    // Handle stop errors
    print('Failed to stop ringtone: $e');
  } else {
    // Handle general errors
    print('Unexpected error: $e');
  }
}
```

## Performance Optimizations

The plugin includes several performance optimizations:

### Lazy Loading
- **Fast initial loading**: Basic information loads quickly
- **Detailed info on demand**: File size, duration, and metadata loaded only when needed
- **Efficient memory usage**: Minimal memory footprint

### Caching
- **Ringtone caching**: Frequently accessed ringtones are cached
- **Title optimization**: Smart title resolution for better performance

### Batch Operations
- **Efficient queries**: Optimized database queries for faster results
- **Limited results**: Configurable limits to prevent memory issues

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ Full | Requires Android API level 21+, includes audio playback |
| iOS | 🚧 In Development | Coming in future updates |
| Web | ❌ Not supported | Platform-specific functionality |
| Desktop | ❌ Not supported | Platform-specific functionality |

## Permissions

### Android

The plugin automatically requests the following permissions:

- `READ_EXTERNAL_STORAGE` - Required to access ringtone files
- Audio playback permissions are handled automatically

### iOS

**Note**: iOS permissions will be documented when iOS support is released.

## Roadmap

### Version 1.2 (Next Release)
- 🍎 iOS support
- 🎛️ Volume control
- ⏱️ Playback controls (pause, resume, seek)
- 📱 Better UI components

### Version 1.3
- 🎯 Enhanced selection features
- 🔄 Ringtone management (set as default, etc.)
- 📝 Improved ringtone title resolution
- 🧪 Comprehensive testing suite

### Future Versions
- 🎨 Custom UI widgets
- 🔧 Advanced configuration options
- 📊 Usage analytics
- 🌐 Cross-platform synchronization

## Example App

Check out the [example app](example/) for a complete implementation showing how to:

- Display a list of available ringtones with enhanced information
- Handle loading states and error handling
- Implement audio playback controls
- Create a user-friendly interface with play/stop functionality
- Use type-specific filtering
- Show detailed ringtone information
- Handle real-time playback status

## Contributing

Contributions are welcome! This is an actively developed plugin, and we'd love your help. Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## Testing

Run the tests using:

```bash
flutter test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.

## Support

If you encounter any issues or have questions, please:

1. Check the [example app](example/) for usage examples
2. Search existing [issues](https://github.com/your-username/jbh_ringtone/issues)
3. Create a new issue with detailed information about your problem

## Acknowledgments

- Flutter team for the excellent plugin development framework
- Android and iOS communities for platform-specific guidance
- Contributors and users for feedback and suggestions

---

**Made with ❤️ for the Flutter community**

*This plugin is actively maintained and developed. Stay tuned for regular updates and new features!*

