import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';

class AttendanceEditData {
  final List<Student> students;
  final Map<String, bool> presentStudents;
  final String attendanceId;
  final String teacherId;
  final String subjectId;
  final String sectionId;
  final LessonTopic lessonTopic;

  const AttendanceEditData({
    required this.students,
    required this.presentStudents,
    required this.attendanceId,
    required this.teacherId,
    required this.subjectId,
    required this.sectionId,
    required this.lessonTopic
  });
}
