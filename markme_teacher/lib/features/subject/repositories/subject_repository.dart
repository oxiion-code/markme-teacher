import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/academic_batch.dart';
import 'package:markme_teacher/core/models/branch.dart';
import 'package:markme_teacher/core/models/course.dart';
import 'package:markme_teacher/core/models/subject.dart';

abstract class SubjectRepository{
  Future<Either<AppFailure,Unit>> addSubject(Subject subject,String teacherId);
  Future<Either<AppFailure,Unit>> deleteSubject(Subject subject,String teacherId);
  Future<Either<AppFailure,Unit>> updateSubject(Subject subject,String teacherId);
  Future<Either<AppFailure,List<Subject>>> getAllSubjects(String teacherId);
  Future<Either<AppFailure,List<Course>>> getAllCourses();
  Future<Either<AppFailure,List<Branch>>> getBranchesForCourse(String courseId);
  Future<Either <AppFailure,List<Subject>>> getSubjectsForBatch(String batchId);
  Future<Either<AppFailure,List<AcademicBatch>>> getBatchesForBranch(String branchId);
}