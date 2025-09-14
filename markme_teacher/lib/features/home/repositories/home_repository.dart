import 'package:markme_teacher/core/models/teacher.dart';

abstract class HomeRepository{
  Stream<Teacher> listenToTeacher(String teacherId);
}