

import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';

abstract class LessonRepository{
  Future<Either<AppFailure,LessonPlan>> addLessonPlanByTeacherId(LessonPlan lessonPlan,String teacherId);
  Future<Either<AppFailure,List<LessonPlan>>> getLessonPlansByTeacherId(String teacherId);
  Future<Either<AppFailure,LessonPlan>> getLessonPlanForAttendance(String teacherId,String sectionId, String subjectId);
  Future<Either<AppFailure,LessonPlan>> deleteLessonPlanByTeacherId(LessonPlan lessonPlan,String teacherId);
}