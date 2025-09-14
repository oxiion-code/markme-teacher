// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';

class Attendance {
  final String attendanceId;
  final String classId; // Link to ClassSession (optional for manual)
  final String studentId;
  final String subjectId;
  final String sectionId;
  final String group; // "all", "grp1", "grp2"
  final int semesterNo;
  final DateTime date;
  final String status; // "present", "absent", "late", "excused"
  final String markedBy; // teacherId or adminId
  final String mode; // manual, biometric, bluetooth, qr, etc.
  final DateTime modifiedAt;
  final LessonTopic? lessonTopic; // <-- NEW (nullable for backward compat)

  Attendance({
    required this.attendanceId,
    required this.classId,
    required this.studentId,
    required this.subjectId,
    required this.sectionId,
    required this.group,
    required this.semesterNo,
    required this.date,
    required this.status,
    required this.markedBy,
    required this.mode,
    required this.modifiedAt,
    this.lessonTopic, // <-- NEW
  });

  Attendance copyWith({
    String? attendanceId,
    String? classId,
    String? studentId,
    String? subjectId,
    String? sectionId,
    String? group,
    int? semesterNo,
    DateTime? date,
    String? status,
    String? markedBy,
    String? mode,
    DateTime? modifiedAt,
    LessonTopic? lessonTopic, // <-- NEW
  }) {
    return Attendance(
      attendanceId: attendanceId ?? this.attendanceId,
      classId: classId ?? this.classId,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
      sectionId: sectionId ?? this.sectionId,
      group: group ?? this.group,
      semesterNo: semesterNo ?? this.semesterNo,
      date: date ?? this.date,
      status: status ?? this.status,
      markedBy: markedBy ?? this.markedBy,
      mode: mode ?? this.mode,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      lessonTopic: lessonTopic ?? this.lessonTopic, // <-- NEW
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendanceId': attendanceId,
      'classId': classId,
      'studentId': studentId,
      'subjectId': subjectId,
      'sectionId': sectionId,
      'group': group,
      'semesterNo': semesterNo,
      'date': date.millisecondsSinceEpoch,
      'status': status,
      'markedBy': markedBy,
      'mode': mode,
      'modifiedAt': modifiedAt.millisecondsSinceEpoch,
      'lessonTopic': lessonTopic?.toMap(), // <-- NEW
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      attendanceId: map['attendanceId'] as String,
      classId: map['classId'] as String,
      studentId: map['studentId'] as String,
      subjectId: map['subjectId'] as String,
      sectionId: map['sectionId'] as String,
      group: map['group'] as String,
      semesterNo: map['semesterNo'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      status: map['status'] as String,
      markedBy: map['markedBy'] as String,
      mode: map['mode'] as String,
      modifiedAt: DateTime.fromMillisecondsSinceEpoch(map['modifiedAt'] as int),
      lessonTopic: map['lessonTopic'] != null
          ? LessonTopic.fromMap(map['lessonTopic'] as Map<String, dynamic>)
          : null, // <-- NEW
    );
  }

  String toJson() => json.encode(toMap());

  factory Attendance.fromJson(String source) =>
      Attendance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Attendance(attendanceId: $attendanceId, classId: $classId, studentId: $studentId, subjectId: $subjectId, sectionId: $sectionId, group: $group, semesterNo: $semesterNo, date: $date, status: $status, markedBy: $markedBy, mode: $mode, modifiedAt: $modifiedAt, lessonTopic: $lessonTopic)';
  }

  @override
  bool operator ==(covariant Attendance other) {
    if (identical(this, other)) return true;

    return other.attendanceId == attendanceId &&
        other.classId == classId &&
        other.studentId == studentId &&
        other.subjectId == subjectId &&
        other.sectionId == sectionId &&
        other.group == group &&
        other.semesterNo == semesterNo &&
        other.date == date &&
        other.status == status &&
        other.markedBy == markedBy &&
        other.mode == mode &&
        other.modifiedAt == modifiedAt &&
        other.lessonTopic == lessonTopic; // <-- NEW
  }

  @override
  int get hashCode {
    return attendanceId.hashCode ^
    classId.hashCode ^
    studentId.hashCode ^
    subjectId.hashCode ^
    sectionId.hashCode ^
    group.hashCode ^
    semesterNo.hashCode ^
    date.hashCode ^
    status.hashCode ^
    markedBy.hashCode ^
    mode.hashCode ^
    modifiedAt.hashCode ^
    lessonTopic.hashCode; // <-- NEW
  }
}
