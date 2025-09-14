import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/student.dart';

abstract class StudentRepository{
  Future<Either<AppFailure,List<Student>>> getStudentsBySectionId(String sectionId);
}