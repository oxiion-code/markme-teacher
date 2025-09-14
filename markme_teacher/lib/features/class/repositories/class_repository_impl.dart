import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';
import 'package:markme_teacher/features/class/models/class_start_data.dart';
import 'package:markme_teacher/features/class/repositories/class_repository.dart';

class ClassRepositoryImpl extends ClassRepository {
  final FirebaseFirestore firestore;

  ClassRepositoryImpl(this.firestore);

  @override
  Future<Either<AppFailure, ClassSession>> startClass(
    ClassSession classSession,
  ) async {
    try {
      await firestore
          .collection('classSessions')
          .doc(classSession.classId)
          .set(classSession.toMap());
      await firestore.collection("teachers").doc(classSession.teacherId).update(
        {"liveClassId": classSession.classId},
      );
      return Right(classSession);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, ClassStartData>> joinLiveClass(
    String classId,
  ) async {
    try {
      final classSnapshot = await firestore
          .collection("classSessions")
          .doc(classId)
          .get();
      if (!classSnapshot.exists) {
        return Left(
          AppFailure(message: "No class exists with current class id"),
        );
      }

      final classData = ClassSession.fromMap(classSnapshot.data()!);

      final studentsSnapshot = await firestore
          .collection("students")
          .where("sectionId", isEqualTo: classData.sectionId)
          .get();

      final students = studentsSnapshot.docs
          .map((doc) => Student.fromMap(doc.data()))
          .toList();

      return Right(ClassStartData(classSession: classData, students: students));
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> endLiveClass(
    String classId,
    String teacherId,
  ) async {
    try {
      await firestore.collection("classSessions").doc(classId).update({
        "status": "ended",
      });
      await firestore.collection("teachers").doc(teacherId).update({
        "liveClassId": null,
      });
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
