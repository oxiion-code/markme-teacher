import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/section.dart';
import 'package:markme_teacher/features/section/repository/section_repository.dart';


class SectionRepositoryImpl extends SectionRepository {
  final FirebaseFirestore firestore;

  SectionRepositoryImpl(this.firestore);

  @override
  Future<Either<AppFailure, Unit>> addSection(String teacherId,
      String sectionId,) async {
    try {
      await firestore.collection('teachers').doc(teacherId).set({
        "assignedClasses": FieldValue.arrayUnion([sectionId]),
      }, SetOptions(merge: true));
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteSection(String teacherId,
      String sectionId,) async {
    try {
      await firestore.collection('teachers').doc(teacherId).update({
        "assignedClasses": FieldValue.arrayRemove([sectionId]),
      });
      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<String>>> getSections(String teacherId) async {
    try {
      final doc = await firestore.collection('teachers').doc(teacherId).get();
      if (!doc.exists) {
        return right([]);
      }
      final data = doc.data();
      final classes =
          (data?['assignedClasses'] as List<dynamic>?)
              ?.map((cl) => cl.toString())
              .toList() ??
              [];
      return Right(classes);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<String>>> getSectionsByFilters({
    required String courseId,
    required String branchId,
    required String batchId,
  }) async {
    try {
      final snapshot = await firestore
          .collection('sections')
          .where('courseId', isEqualTo: courseId)
          .where('branchId', isEqualTo: branchId)
          .where('batchId', isEqualTo: batchId)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Right([]);
      }

      final sectionIds = snapshot.docs.map((doc) => doc.id).toList();

      return Right(sectionIds);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Section>> getSectionDetails(String sectionId) async {
    try{
     final doc=await firestore.collection('sections').doc(sectionId).get();
      if(doc.exists){
        final section=Section.fromMap(doc.data()!);
        return Right(section);
      }else{
        return Left(AppFailure(message: "Section not found"));
      }
    }catch(e){
      return Left(AppFailure(message: e.toString()));
    }
  }
}

