import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/features/student/repositories/student_repository.dart';

class StudentRepositoryImpl extends StudentRepository {
  FirebaseFirestore firestore;
  StudentRepositoryImpl(this.firestore);
  @override
  Future<Either<AppFailure, List<Student>>> getStudentsBySectionId(
    String sectionId,
  ) async {
    try {
      final docsSnapshot = await firestore
          .collection("students")
          .where("sectionId", isEqualTo: sectionId)
          .get();
      final students = docsSnapshot.docs
          .map((student) => Student.fromMap(student.data()))
          .toList();
      return Right(students);
    } on FirebaseException catch (e) {
      return Left(AppFailure(message: "Firestore error: ${e.message}"));
    } on StateError catch (e) {
      return Left(AppFailure(message: "State error: ${e.message}"));
    } catch (e) {
      return Left(AppFailure(message: "Unexpected error: ${e.toString()}"));
    }
  }
}
