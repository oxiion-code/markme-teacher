import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';
import 'package:markme_teacher/features/lesson_plan/repositories/lesson_plan_repository.dart';

class LessonRepositoryImpl extends LessonRepository {
  FirebaseFirestore firestore;
  LessonRepositoryImpl(this.firestore);
  @override
  Future<Either<AppFailure, LessonPlan>> addLessonPlanByTeacherId(
    LessonPlan lessonPlan,
    String teacherId,
  ) async {
    try {
      await firestore
          .collection("teachers")
          .doc(teacherId)
          .collection("lessonPlans")
          .doc(lessonPlan.sectionId)
          .set(lessonPlan.toMap(), SetOptions(merge: true));
      return Right(lessonPlan);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<LessonPlan>>> getLessonPlansByTeacherId(
    String teacherId,
  ) async {
    try {
      final querySnapshot = await firestore
          .collection("teachers")
          .doc(teacherId)
          .collection("lessonPlans")
          .get();
      final lessonPlans = querySnapshot.docs
          .map((doc) => LessonPlan.fromMap(doc.data()))
          .toList();
      return Right(lessonPlans);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, LessonPlan>> deleteLessonPlanByTeacherId(
    LessonPlan lessonPlan,
    String teacherId,
  ) async {
    try {
      await firestore
          .collection("teachers")
          .doc(teacherId)
          .collection("lessonPlans")
          .doc(lessonPlan.sectionId)
          .delete();
      return Right(lessonPlan);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, LessonPlan>> getLessonPlanForAttendance(
      String teacherId,
      String sectionId,
      String subjectId,
      ) async {
    try {
      final docSnapshot = await firestore
          .collection("teachers")
          .doc(teacherId)
          .collection("lessonPlans")
          .doc(sectionId)
          .get();

      if (!docSnapshot.exists) {
        return left(AppFailure(message: "No lesson plan found for this section"));
      }

      final data = docSnapshot.data();
      if (data == null) {
        return left(AppFailure(message: "Lesson plan data is null"));
      }

      // Convert Firestore map → LessonPlan
      final lessonPlan = LessonPlan.fromMap(data);

      // Extra check: ensure subjectId matches
      if (lessonPlan.subjectId != subjectId) {
        return left(AppFailure(message: "Lesson plan not found for this subject"));
      }

      return right(lessonPlan);
    } catch (e) {
      return left(AppFailure(message: "Failed to fetch lesson plan: $e"));
    }
  }

}
