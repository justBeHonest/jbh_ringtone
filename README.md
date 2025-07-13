# jbh_ringtone

[![pub package](https://img.shields.io/pub/v/jbh_ringtone.svg)](https://pub.dev/packages/jbh_ringtone)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin that provides easy access to device ringtones. **Currently in active development** - this plugin allows you to retrieve the list of available ringtones with their IDs, titles, and URIs.

## 🚧 Current Status

This plugin is **actively being developed** and currently supports:
- ✅ **Android**: Full support for retrieving ringtones
- 🚧 **iOS**: Coming soon (in development)
- 📋 **Future plans**: Audio preview, selection features, and enhanced functionality

## Features

### Currently Available
- 📱 **Android support**: Works on Android devices (API level 21+)
- 🎵 **Ringtone listing**: Retrieves available ringtones with IDs, titles, and URIs
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

### Basic Usage

```dart
import 'package:jbh_ringtone/jbh_ringtone.dart';

void main() async {
  // Create an instance of JbhRingtone
  JbhRingtone ringtone = JbhRingtone();
  
  try {
    // Get all available ringtones
    List<Map<String, dynamic>> ringtones = await ringtone.getRingtones();
    
    print('Found ${ringtones.length} ringtones');
    
    // Display each ringtone
    for (var ringtone in ringtones) {
      print('Title: ${ringtone['title']}');
      print('ID: ${ringtone['id']}');
      print('URI: ${ringtone['uri']}');
      print('---');
    }
  } catch (e) {
    print('Error: $e');
  }
}
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
      appBar: AppBar(title: Text('Available Ringtones')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView.builder(
                  itemCount: _ringtones.length,
                  itemBuilder: (context, index) {
                    final ringtone = _ringtones[index];
                    return ListTile(
                      title: Text(ringtone['title']),
                      subtitle: Text('ID: ${ringtone['id']}'),
                      trailing: Icon(Icons.music_note),
                      onTap: () {
                        // Handle ringtone selection
                        print('Selected: ${ringtone['title']}');
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

##### `getRingtones()`

Retrieves all available ringtones from the device.

**Returns:** `Future<List<Map<String, dynamic>>>`

**Example:**
```dart
List<Map<String, dynamic>> ringtones = await ringtone.getRingtones();
```

**Return Data Structure:**
```dart
[
  {
    'id': 1,
    'title': 'Default Ringtone',
    'uri': 'content://media/external/audio/media/1'
  },
  {
    'id': 2,
    'title': 'Custom Ringtone',
    'uri': 'content://media/external/audio/media/2'
  }
]
```

##### `getPlatformVersion()`

Gets the current platform version.

**Returns:** `Future<String?>`

**Example:**
```dart
String? version = await ringtone.getPlatformVersion();
// Returns: "Android 13" or "iOS 16.0"
```

## Data Structure

Each ringtone object contains the following properties:

| Property | Type | Description |
|----------|------|-------------|
| `id` | `int` | Unique identifier for the ringtone |
| `title` | `String` | Human-readable name of the ringtone |
| `uri` | `String` | Content URI for accessing the ringtone file |

## Error Handling

The plugin provides comprehensive error handling:

```dart
try {
  List<Map<String, dynamic>> ringtones = await ringtone.getRingtones();
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

