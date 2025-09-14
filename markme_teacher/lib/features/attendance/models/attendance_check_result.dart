import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';

class AttendanceCheckResult {
  final String attendanceId;
  final bool alreadyTaken;
  final Map<String, bool> presentStudents;
  final LessonTopic? lessonTopic;

  AttendanceCheckResult({
    required this.attendanceId,
    required this.alreadyTaken,
    this.presentStudents = const {},
    this.lessonTopic
  });
}