// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClassSession {
  final String classId;
  final String subjectId;
  final String subjectName;
  final String sectionId;
  final String sectionName;
  final String teacherId;
  final String teacherName;
  final String roomName;

  final int semesterNo; // 🔹 NEW FIELD

  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // "scheduled", "live", "ended", "cancelled"

  final String sessionType; // "theory", "lab", "tutorial", "seminar", "extra"
  final String group;       // "all", "grp1", "grp2"

  final String? attendanceId; // link to attendance batch (nullable)

  ClassSession({
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.sectionId,
    required this.sectionName,
    required this.teacherId,
    required this.teacherName,
    required this.roomName,
    required this.semesterNo, // 🔹 ADDED TO CONSTRUCTOR
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.sessionType,
    required this.group,
    this.attendanceId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classId': classId,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'sectionId': sectionId,
      'sectionName': sectionName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'roomName': roomName,
      'semesterNo': semesterNo, // 🔹 ADDED
      'date': date.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'status': status,
      'sessionType': sessionType,
      'group': group,
      'attendanceId': attendanceId,
    };
  }

  factory ClassSession.fromMap(Map<String, dynamic> map) {
    return ClassSession(
      classId: map['classId'] as String,
      subjectId: map['subjectId'] as String,
      subjectName: map['subjectName'] as String,
      sectionId: map['sectionId'] as String,
      sectionName: map['sectionName'] as String,
      teacherId: map['teacherId'] as String,
      teacherName: map['teacherName'] as String,
      roomName: map['roomName'] as String,
      semesterNo: map['semesterNo'] as int, // 🔹 ADDED
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      status: map['status'] as String,
      sessionType: map['sessionType'] as String,
      group: map['group'] as String,
      attendanceId: map['attendanceId'] != null ? map['attendanceId'] as String : null,
    );
  }

  ClassSession copyWith({
    String? classId,
    String? subjectId,
    String? subjectName,
    String? sectionId,
    String? sectionName,
    String? teacherId,
    String? teacherName,
    String? roomName,
    int? semesterNo, // 🔹 ADDED
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? sessionType,
    String? group,
    String? attendanceId,
  }) {
    return ClassSession(
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      roomName: roomName ?? this.roomName,
      semesterNo: semesterNo ?? this.semesterNo, // 🔹 ADDED
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      sessionType: sessionType ?? this.sessionType,
      group: group ?? this.group,
      attendanceId: attendanceId ?? this.attendanceId,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassSession.fromJson(String source) =>
      ClassSession.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ClassSession(classId: $classId, subjectId: $subjectId, subjectName: $subjectName, sectionId: $sectionId, sectionName: $sectionName, teacherId: $teacherId, teacherName: $teacherName, roomName: $roomName, semesterNo: $semesterNo, date: $date, startTime: $startTime, endTime: $endTime, status: $status, sessionType: $sessionType, group: $group, attendanceId: $attendanceId)';
  }

  @override
  bool operator ==(covariant ClassSession other) {
    if (identical(this, other)) return true;

    return
      other.classId == classId &&
          other.subjectId == subjectId &&
          other.subjectName == subjectName &&
          other.sectionId == sectionId &&
          other.sectionName == sectionName &&
          other.teacherId == teacherId &&
          other.teacherName == teacherName &&
          other.roomName == roomName &&
          other.semesterNo == semesterNo && // 🔹 ADDED
          other.date == date &&
          other.startTime == startTime &&
          other.endTime == endTime &&
          other.status == status &&
          other.sessionType == sessionType &&
          other.group == group &&
          other.attendanceId == attendanceId;
  }

  @override
  int get hashCode {
    return classId.hashCode ^
    subjectId.hashCode ^
    subjectName.hashCode ^
    sectionId.hashCode ^
    sectionName.hashCode ^
    teacherId.hashCode ^
    teacherName.hashCode ^
    roomName.hashCode ^
    semesterNo.hashCode ^ // 🔹 ADDED
    date.hashCode ^
    startTime.hashCode ^
    endTime.hashCode ^
    status.hashCode ^
    sessionType.hashCode ^
    group.hashCode ^
    attendanceId.hashCode;
  }
}
