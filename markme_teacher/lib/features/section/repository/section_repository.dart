import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/section.dart';

abstract class SectionRepository {
  Future<Either<AppFailure, Unit>> addSection(
    String teacherId,
    String sectionId,
  );
  Future<Either<AppFailure, Unit>> deleteSection(
    String teacherId,
    String sectionId,
  );
  Future<Either<AppFailure, List<String>>> getSections(String teacherId);
  Future<Either<AppFailure, List<String>>> getSectionsByFilters({
    required String courseId,
    required String branchId,
    required String batchId,
  });
  Future<Either<AppFailure,Section>> getSectionDetails(String sectionId);
}
