class JbhRingtoneModel {
  final int id;
  final String title;
  final String uri;
  final RingtoneType type;

  JbhRingtoneModel({required this.id, required this.title, required this.uri, required this.type});

  factory JbhRingtoneModel.fromMap(Map<String, dynamic> map) {
    return JbhRingtoneModel(
      id: map['id'] as int,
      title: map['title'] as String,
      uri: map['uri'] as String,
      type: RingtoneType.values.firstWhere((e) => e.value == map['type'], orElse: () => RingtoneType.ringtone),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'uri': uri, 'type': type.value};
  }

  @override
  String toString() {
    return 'JbhRingtoneModel(id: $id, title: $title, uri: $uri, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JbhRingtoneModel && other.id == id && other.title == title && other.uri == uri && other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ uri.hashCode ^ type.hashCode;
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
