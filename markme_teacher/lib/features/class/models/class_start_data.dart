import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';

class ClassStartData{
  final List<Student> students;
  final ClassSession classSession;
  const ClassStartData({
    required this.students,
    required this.classSession
});
}