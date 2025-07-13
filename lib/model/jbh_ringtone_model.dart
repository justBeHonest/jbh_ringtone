class JbhRingtoneModel {
  final int id;
  final String title;
  final String displayTitle;
  final String fileName;
  final String uri;
  final String uriType;
  final String? filePath;
  final int fileSize;
  final int duration;
  final RingtoneType type;
  final bool isDefault;

  JbhRingtoneModel({
    required this.id,
    required this.title,
    required this.displayTitle,
    required this.fileName,
    required this.uri,
    required this.uriType,
    this.filePath,
    required this.fileSize,
    required this.duration,
    required this.type,
    required this.isDefault,
  });

  factory JbhRingtoneModel.fromMap(Map<String, dynamic> map) {
    return JbhRingtoneModel(
      id: map['id'] as int,
      title: map['title'] as String,
      displayTitle: map['displayTitle'] as String? ?? map['title'] as String,
      fileName: map['fileName'] as String? ?? '',
      uri: map['uri'] as String,
      uriType: map['uriType'] as String? ?? 'unknown',
      filePath: map['filePath'] as String?,
      fileSize: map['fileSize'] as int? ?? 0,
      duration: map['duration'] as int? ?? 0,
      type: RingtoneType.values.firstWhere((e) => e.value == map['type'], orElse: () => RingtoneType.ringtone),
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'displayTitle': displayTitle,
      'fileName': fileName,
      'uri': uri,
      'uriType': uriType,
      'filePath': filePath,
      'fileSize': fileSize,
      'duration': duration,
      'type': type.value,
      'isDefault': isDefault,
    };
  }

  // Kullanışlı getter'lar
  String get formattedDuration {
    if (duration <= 0) return 'Unknown';
    final minutes = duration ~/ 60000;
    final seconds = (duration % 60000) ~/ 1000;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedFileSize {
    if (fileSize <= 0) return 'Unknown';
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  String toString() {
    return 'JbhRingtoneModel(id: $id, title: $title, displayTitle: $displayTitle, uri: $uri, duration: $formattedDuration, size: $formattedFileSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JbhRingtoneModel && other.id == id && other.uri == uri;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uri.hashCode;
  }
}

enum RingtoneType {
  ringtone(1, 'Ringtone'),
  notification(2, 'Notification'),
  alarm(4, 'Alarm'),
  all(7, 'All');

  const RingtoneType(this.value, this.displayName);

  final int value;
  final String displayName;

  static RingtoneType fromValue(int value) {
    return RingtoneType.values.firstWhere((type) => type.value == value, orElse: () => RingtoneType.ringtone);
  }
}
