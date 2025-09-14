import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';
import 'package:markme_teacher/features/class/models/class_start_data.dart';

abstract class ClassRepository{
  Future<Either<AppFailure,ClassSession>> startClass(ClassSession classSession);
  Future<Either<AppFailure,ClassStartData>> joinLiveClass(String classId);
  Future<Either<AppFailure,Unit>> endLiveClass(String classId, String teacherId);
}