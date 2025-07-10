# jbh_ringtone Example App

This example demonstrates how to use the `jbh_ringtone` plugin in a Flutter application.

## Features Demonstrated

- 📱 **Cross-platform ringtone access**: Works on both Android and iOS
- 🎵 **Real ringtone names**: Shows actual ringtone names as they appear on the device
- 🔄 **Loading states**: Proper loading indicators while fetching ringtones
- ⚠️ **Error handling**: Comprehensive error handling with retry functionality
- 🎨 **Modern UI**: Material Design 3 interface with cards and animations
- 🔍 **Detailed information**: Displays ID, title, and URI for each ringtone

## Screenshots

The app displays:
- A list of all available ringtones on the device
- Loading indicator while fetching data
- Error messages with retry button if something goes wrong
- Empty state when no ringtones are found
- Tap feedback when selecting a ringtone

## Getting Started

1. **Run the example:**
   ```bash
   cd example
   flutter run
   ```

2. **Test on different devices:**
   - Connect an Android device or start an emulator
   - Connect an iOS device or start a simulator
   - The app will automatically detect the platform and show appropriate ringtones

## Code Structure

### Main App (`lib/main.dart`)
- Material Design 3 theme setup
- Navigation to the ringtone list page

### Ringtone List Page (`lib/main.dart` - `RingtoneListPage`)
- State management for loading, error, and success states
- Integration with the `jbh_ringtone` plugin
- UI components for displaying ringtones

### Key Features

#### Loading State
```dart
if (_isLoading) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Zil sesleri yükleniyor...'),
      ],
    ),
  );
}
```

#### Error Handling
```dart
if (_error != null) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, size: 64, color: Colors.red),
        SizedBox(height: 16),
        Text('Hata: $_error', textAlign: TextAlign.center),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _loadRingtones,
          child: Text('Tekrar Dene'),
        ),
      ],
    ),
  );
}
```

#### Ringtone List
```dart
ListView.builder(
  itemCount: _ringtones.length,
  itemBuilder: (context, index) {
    final ringtone = _ringtones[index];
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(Icons.music_note),
        title: Text(ringtone['title'] ?? 'Bilinmeyen'),
        subtitle: Text(ringtone['uri'] ?? ''),
        trailing: Text('ID: ${ringtone['id']}'),
        onTap: () {
          // Handle ringtone selection
        },
      ),
    );
  },
)
```

## Platform-Specific Behavior

### Android
- Shows all system and custom ringtones
- Displays real ringtone names from the device
- Automatically handles permissions

### iOS
- Shows all available ringtones
- Displays system-provided names
- No additional permissions required

## Testing

To test the example app:

1. **Unit Tests:**
   ```bash
   flutter test
   ```

2. **Integration Tests:**
   ```bash
   flutter test integration_test/
   ```

3. **Manual Testing:**
   - Run on different devices
   - Test error scenarios (e.g., no permissions)
   - Verify ringtone names are correct

## Troubleshooting

### Common Issues

1. **No ringtones found:**
   - Check if the device has ringtones
   - Verify permissions on Android
   - Try refreshing the list

2. **Permission errors:**
   - Grant storage permissions on Android
   - Check device settings

3. **Build errors:**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter version compatibility

## Contributing

This example app is part of the `jbh_ringtone` plugin. To contribute:

1. Fork the repository
2. Make your changes
3. Test thoroughly on both platforms
4. Submit a pull request

## License

MIT License

Copyright (c) 2025 justBeHonest

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
