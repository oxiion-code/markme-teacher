import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_plan.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';

import '../models/attendance_check_result.dart';

abstract class AttendanceRepository {
  Future<Either<AppFailure, String>> createAttendanceBatch(
    ClassSession classData,
    List<Student> students,
  );

  Future<Either<AppFailure, Unit>> markAttendanceManual(
    String attendanceId,
    Map<String, bool> selectedStudents,
    String mode,
    String teacherId,
    LessonTopic lessonTopic,
    String sectionId,
  );

  Future<Either<AppFailure, Map<String, bool>>> getAttendanceDataById(
    String attendanceId,
  );

  Future<Either<AppFailure, AttendanceCheckResult>> createOrGetAttendance(
    ClassSession classData,
    List<Student> students,
  );
  Future<Either<AppFailure, Unit>> deleteAttendanceById(
    String attendanceId,
    String classId,
    String lessonNumber,
    String sectionId,
    String teacherId,

  );
}
