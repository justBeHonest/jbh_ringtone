# jbh_ringtone

[![pub package](https://img.shields.io/pub/v/jbh_ringtone.svg)](https://pub.dev/packages/jbh_ringtone)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin that provides easy access to device ringtones. **Currently in active development** - this plugin allows you to retrieve the list of available ringtones with their IDs, titles, URIs, and types.

## 🚧 Current Status

This plugin is **actively being developed** and currently supports:
- ✅ **Android**: Full support for retrieving ringtones with different types
- 🚧 **iOS**: Coming soon (in development)
- 📋 **Future plans**: Audio preview, selection features, and enhanced functionality

## Features

### Currently Available
- 📱 **Android support**: Works on Android devices (API level 21+)
- 🎵 **Ringtone listing**: Retrieves available ringtones with IDs, titles, URIs, and types
- 🎯 **Type-specific methods**: Get ringtones by type (ringtone, notification, alarm)
- 🔍 **Flexible filtering**: Custom filter options for multiple ringtone types
- 📦 **Typed models**: Strongly typed `JbhRingtoneModel` instead of generic maps
- ⚡ **Easy to use**: Simple API with no complex setup required
- 🛡️ **Error handling**: Robust error handling with meaningful error messages
- 📦 **No dependencies**: Lightweight with minimal external dependencies

### Coming Soon
- 🍎 **iOS support**: Full cross-platform compatibility
- 🎧 **Audio preview**: Listen to ringtones before selection
- 🎯 **Enhanced selection**: Better ringtone management features
- 📝 **Improved titles**: Better ringtone name resolution

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

### Basic Usage with New API

```dart
import 'package:jbh_ringtone/jbh_ringtone.dart';

void main() async {
  // Create an instance of JbhRingtone
  JbhRingtone ringtone = JbhRingtone();
  
  try {
    // Get all ringtones (new typed API)
    List<JbhRingtoneModel> allRingtones = await ringtone.getAllRingtones();
    
    print('Found ${allRingtones.length} ringtones');
    
    // Display each ringtone with type information
    for (var ringtone in allRingtones) {
      print('Title: ${ringtone.title}');
      print('ID: ${ringtone.id}');
      print('URI: ${ringtone.uri}');
      print('Type: ${ringtone.type.displayName}');
      print('---');
    }
  } catch (e) {
    print('Error: $e');
  }
}
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

### Advanced Usage with UI

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Ringtones'),
        actions: [
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
                    return ListTile(
                      title: Text(ringtone.title),
                      subtitle: Text('Type: ${ringtone.type.displayName}'),
                      trailing: Icon(Icons.music_note),
                      onTap: () {
                        // Handle ringtone selection
                        print('Selected: ${ringtone.title} (${ringtone.type.displayName})');
                      },
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

**Returns:** `Future<List<Map<String, dynamic>>>`

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

Represents a single ringtone with its properties.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | `int` | Unique identifier for the ringtone |
| `title` | `String` | Human-readable name of the ringtone |
| `uri` | `String` | Content URI for accessing the ringtone file |
| `type` | `RingtoneType` | Type of the ringtone (ringtone, notification, alarm, all) |

#### Methods

##### `fromMap(Map<String, dynamic> map)`

Creates a JbhRingtoneModel from a map.

##### `toMap()`

Converts the model to a map.

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
  } else {
    // Handle general errors
    print('Unexpected error: $e');
  }
}
```

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ Full | Requires Android API level 21+ |
| iOS | 🚧 In Development | Coming in future updates |
| Web | ❌ Not supported | Platform-specific functionality |
| Desktop | ❌ Not supported | Platform-specific functionality |

## Permissions

### Android

The plugin automatically requests the following permissions:

- `READ_EXTERNAL_STORAGE` - Required to access ringtone files

### iOS

**Note**: iOS permissions will be documented when iOS support is released.

## Roadmap

### Version 1.1 (Next Release)
- 🍎 iOS support
- 🎧 Basic audio preview functionality
- 📝 Improved ringtone title resolution

### Future Versions
- 🎯 Enhanced selection features
- 🔄 Ringtone management (set as default, etc.)
- 📱 Better UI components
- 🧪 Comprehensive testing suite

## Example App

Check out the [example app](example/) for a complete implementation showing how to:

- Display a list of available ringtones
- Handle loading states
- Implement error handling
- Create a user-friendly interface
- Use type-specific filtering

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

---

**Made with ❤️ for the Flutter community**

*This plugin is actively maintained and developed. Stay tuned for regular updates and new features!*

