/// Represents a single occupied cell in a weekly timetable — one subject,
/// taught by one teacher, in one room, at one (day, timeSlot) coordinate.
///
/// Produced by the AI Scheduling module (Genetic Algorithm + CSP validation
/// described in the proposal's methodology) and consumed directly by
/// [TimetableGrid] for rendering.
class ScheduleSlotModel {
  /// Day of the week this slot falls on, e.g. "Monday". Used as the
  /// column key when laid out in [TimetableGrid].
  final String day;

  /// Time range this slot occupies, e.g. "10:00 - 11:00". Used as the
  /// row key when laid out in [TimetableGrid].
  final String timeSlot;

  final String subject;
  final String teacher;
  final String room;

  /// True when the originally assigned [teacher] is unavailable (leave /
  /// emergency) and the AI substitution engine has assigned a replacement.
  final bool isSubstituted;

  /// The replacement teacher's name, populated only when [isSubstituted]
  /// is true. Null otherwise.
  final String? substituteTeacher;

  const ScheduleSlotModel({
    required this.day,
    required this.timeSlot,
    required this.subject,
    required this.teacher,
    required this.room,
    this.isSubstituted = false,
    this.substituteTeacher,
  });

  /// The name that should actually be displayed for "who is teaching" —
  /// the substitute if one has been assigned, otherwise the original
  /// teacher. Keeps this logic out of the UI layer.
  String get effectiveTeacher =>
      isSubstituted && substituteTeacher != null ? substituteTeacher! : teacher;

  factory ScheduleSlotModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSlotModel(
      day: json['day'] as String,
      timeSlot: json['timeSlot'] as String,
      subject: json['subject'] as String,
      teacher: json['teacher'] as String,
      room: json['room'] as String,
      isSubstituted: json['isSubstituted'] as bool? ?? false,
      substituteTeacher: json['substituteTeacher'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'timeSlot': timeSlot,
      'subject': subject,
      'teacher': teacher,
      'room': room,
      'isSubstituted': isSubstituted,
      'substituteTeacher': substituteTeacher,
    };
  }

  ScheduleSlotModel copyWith({
    String? day,
    String? timeSlot,
    String? subject,
    String? teacher,
    String? room,
    bool? isSubstituted,
    String? substituteTeacher,
  }) {
    return ScheduleSlotModel(
      day: day ?? this.day,
      timeSlot: timeSlot ?? this.timeSlot,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      room: room ?? this.room,
      isSubstituted: isSubstituted ?? this.isSubstituted,
      substituteTeacher: substituteTeacher ?? this.substituteTeacher,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleSlotModel &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          timeSlot == other.timeSlot;

  @override
  int get hashCode => Object.hash(day, timeSlot);
}
