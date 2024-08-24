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
  final double originalTime;
  final double originalStrokeRate;
  final double sectionLength;
  final double newTime;
  final double newStrokeRate;
  final double newStrokeLength;
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
      originalTime: json[AllValuesFields.originalTime] as double,
      originalStrokeRate: json[AllValuesFields.originalStrokeRate] as double,
      sectionLength: json[AllValuesFields.sectionLength] as double,
      newTime: json[AllValuesFields.newTime] as double,
      newStrokeRate: json[AllValuesFields.newStrokeRate] as double,
      newStrokeLength: json[AllValuesFields.newStrokeLength] as double,
      date: json[AllValuesFields.date] as String,
      noteText: json[AllValuesFields.noteText] as String,
    );
  }

  AllValues copy({
    String? id,
    double? originalTime,
    double? originalStrokeRate,
    double? sectionLength,
    double? sectionTime,
    double? newTime,
    double? newStrokeRate,
    double? newStrokeLength,
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
