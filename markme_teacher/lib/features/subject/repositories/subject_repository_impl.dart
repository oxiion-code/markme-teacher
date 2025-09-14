import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/academic_batch.dart';
import 'package:markme_teacher/core/models/branch.dart';
import 'package:markme_teacher/core/models/course.dart';
import 'package:markme_teacher/core/models/subject.dart';
import 'package:markme_teacher/features/subject/repositories/subject_repository.dart';

class SubjectRepositoryImpl extends SubjectRepository {
  final FirebaseFirestore firestore;
  SubjectRepositoryImpl(this.firestore);

  @override
  Future<Either<AppFailure, Unit>> addSubject(
    Subject subject,
    String teacherId,
  ) async {
    try {
      await firestore.collection('teachers').doc(teacherId).update({
        "subjects": FieldValue.arrayUnion([subject.toMap()]),
      });
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteSubject(
      Subject subject,
      String teacherId,
      ) async {
    try {
      final docRef = firestore.collection('teachers').doc(teacherId);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        return Left(AppFailure(message: "Teacher not found"));
      }

      List subjects = List.from(docSnap.data()?['subjects'] ?? []);

      // remove subject by subjectId
      subjects.removeWhere((s) => s['subjectId'] == subject.subjectId);

      await docRef.update({'subjects': subjects});

      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Subject>>> getAllSubjects(
    String teacherId,
  ) async {
    try {
      final docSnap = await firestore
          .collection('teachers')
          .doc(teacherId)
          .get();
      if (!docSnap.exists) {
        return Left(AppFailure(message: "Teacher not found"));
      }
      final data = docSnap.data();
      if (data == null || data['subjects'] == null) {
        return Right([]);
      }
      final subjectList = (data['subjects'] as List)
          .map(
            (subjectMap) => Subject.fromMap(subjectMap as Map<String, dynamic>),
          )
          .toList();
      return Right(subjectList);
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateSubject(
    Subject subject,
    String teacherId,
  ) async {
    try {
      final docRef = firestore.collection('teachers').doc(teacherId);

      final docSnap = await docRef.get();
      if (docSnap.exists) {
        List subjects = docSnap.data()?['subjects'] ?? [];
        int index = subjects.indexWhere(
          (s) => s['subjectId'] == subject.subjectId,
        );
        if (index != -1) {
          subjects[index] = subject.toMap();
          await docRef.update({'subjects': subjects});
        }
      }
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Subject>>> getSubjectsForBatch(
    String batchId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('subjects')
          .where('batchId', isEqualTo: batchId)
          .get();
      final subjects = snapshot.docs
          .map((subject) => Subject.fromMap(subject.data()))
          .toList();
      return Right(subjects);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Course>>> getAllCourses() async {
    try {
      final snapshot = await firestore.collection('courses').get();
      final courses = snapshot.docs
          .map((course) => Course.fromMap(course.data()))
          .toList();
      return Right(courses);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Branch>>> getBranchesForCourse(
    String courseId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('branches')
          .where('courseId', isEqualTo: courseId)
          .get();
      final branches = snapshot.docs
          .map((branch) => Branch.fromMap(branch.data()))
          .toList();
      return Right(branches);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<AcademicBatch>>> getBatchesForBranch(
    String branchId,
  ) async {
    try {
      final snapshot = await firestore
          .collection('academicBatches')
          .where('branchId', isEqualTo: branchId)
          .get();
      final batches = snapshot.docs
          .map((batch) => AcademicBatch.fromMap(batch.data()))
          .toList();
      return Right(batches);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
