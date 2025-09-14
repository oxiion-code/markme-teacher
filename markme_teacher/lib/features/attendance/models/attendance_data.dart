import 'package:markme_teacher/core/models/student.dart';

class AttendanceData {
  final String attendanceId;
  final String teacherId;
  final String sectionId;
  final String subjectId;
  final List<Student> students;
  const AttendanceData({
    required this.attendanceId,
    required this.students,
    required this.teacherId,
    required this.sectionId,
    required this.subjectId,
  });
}
