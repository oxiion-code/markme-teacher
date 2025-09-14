import 'package:equatable/equatable.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';

import '../../lesson_plan/models/lesson_topic.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object?> get props => [];
}

class CreateOrGetAttendanceForLiveClass extends AttendanceEvent {
  final List<Student> students;
  final ClassSession classData;
  const CreateOrGetAttendanceForLiveClass(this.students, this.classData);
  @override
  List<Object?> get props => [students, classData];
}

class MarkAttendanceForLiveClass extends AttendanceEvent {
  final String attendanceId;
  final Map<String, bool> selectedStudents;
  final String mode;
  final String teacherId;
  final LessonTopic selectedTopic;
  final String sectionId;
  const MarkAttendanceForLiveClass(
    this.attendanceId,
    this.selectedStudents,
    this.teacherId,
    this.mode,
    this.selectedTopic,
    this.sectionId,
  );
  @override
  List<Object?> get props => [attendanceId, selectedStudents, mode, teacherId];
}

class DeleteLiveAttendanceEvent extends AttendanceEvent {
  final String attendanceId;
  final String classId;
  final String lessonNumber;
  final String teacherId;
  final String sectionId;
  const DeleteLiveAttendanceEvent({
    required this.attendanceId,
    required this.classId,
    required this.lessonNumber,
    required this.teacherId,
    required this.sectionId,
  });
  @override
  List<Object?> get props => [
    attendanceId,
    classId,
    lessonNumber,
    teacherId,
    sectionId,
  ];
}
