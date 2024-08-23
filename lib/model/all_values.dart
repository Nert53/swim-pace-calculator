const String tableAllValues = 'masterTable';

class AllValuesFields {
  static final List<String> values = [
    id,
    originalTime,
    originalStrokeRate,
    sectionLength,
    newTime,
    newStrokeRate,
    newStrokeLength,
    date,
    noteText
  ];

  static const String id = '_id';
  static const String originalTime = 'originalTime';
  static const String originalStrokeRate = 'originalStrokeRate';
  static const String sectionLength = 'sectionLength';
  static const String newTime = 'newTime';
  static const String newStrokeRate = 'newStrokeRate';
  static const String newStrokeLength = 'newStrokeLength';
  static const String date = 'date';
  static const String noteText = 'noteText';
}

class AllValues {
  final String id;
  final String originalTime;
  final String originalStrokeRate;
  final String sectionLength;
  final String newTime;
  final String newStrokeRate;
  final String newStrokeLength;
  final String date;
  String noteText;

  AllValues({
    required this.id,
    required this.originalTime,
    required this.originalStrokeRate,
    required this.sectionLength,
    required this.newTime,
    required this.newStrokeRate,
    required this.newStrokeLength,
    required this.date,
    this.noteText = '',
  });

  Map<String, Object?> toJson() {
    return {
      AllValuesFields.id: id,
      AllValuesFields.originalTime: originalTime,
      AllValuesFields.originalStrokeRate: originalStrokeRate,
      AllValuesFields.sectionLength: sectionLength,
      AllValuesFields.newTime: newTime,
      AllValuesFields.newStrokeRate: newStrokeRate,
      AllValuesFields.newStrokeLength: newStrokeLength,
      AllValuesFields.date: date,
      AllValuesFields.noteText: noteText,
    };
  }

  static AllValues fromJson(Map<String, Object?> json) {
    return AllValues(
      id: json[AllValuesFields.id] as String,
      originalTime: json[AllValuesFields.originalTime] as String,
      originalStrokeRate: json[AllValuesFields.originalStrokeRate] as String,
      sectionLength: json[AllValuesFields.sectionLength] as String,
      newTime: json[AllValuesFields.newTime] as String,
      newStrokeRate: json[AllValuesFields.newStrokeRate] as String,
      newStrokeLength: json[AllValuesFields.newStrokeLength] as String,
      date: json[AllValuesFields.date] as String,
      noteText: json[AllValuesFields.noteText] as String,
    );
  }

  AllValues copy({
    String? id,
    String? originalTime,
    String? originalStrokeRate,
    String? sectionLength,
    String? sectionTime,
    String? newTime,
    String? newStrokeRate,
    String? newStrokeLength,
    String? date,
    String? noteText,
  }) =>
      AllValues(
        id: id ?? this.id,
        originalTime: originalTime ?? this.originalTime,
        originalStrokeRate: originalStrokeRate ?? this.originalStrokeRate,
        sectionLength: sectionTime ?? this.sectionLength,
        newTime: newTime ?? this.newTime,
        newStrokeRate: newStrokeRate ?? this.newStrokeRate,
        newStrokeLength: newStrokeLength ?? this.newStrokeLength,
        date: date ?? this.date,
        noteText: noteText ?? this.noteText,
      );
}
