

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_teacher/core/error/failure.dart';
import 'package:markme_teacher/core/models/student.dart';
import 'package:markme_teacher/features/attendance/repositories/attendance_repository.dart';
import 'package:markme_teacher/features/class/models/class_session.dart';
import 'package:markme_teacher/features/lesson_plan/models/lesson_topic.dart';

import '../models/attendance_check_result.dart';

class AttendanceRepositoryImpl extends AttendanceRepository {
  final FirebaseFirestore firestore;

  AttendanceRepositoryImpl(this.firestore);

  @override
  Future<Either<AppFailure, AttendanceCheckResult>> createOrGetAttendance(
      ClassSession classData,
      List<Student> students,) async {
    try {
      final uniquePart = classData.classId.replaceFirst("CLS-", "");
      final attendanceId = "ATD-$uniquePart";
      final attendanceRef = firestore
          .collection("attendance")
          .doc(attendanceId);

      final attendanceDoc = await attendanceRef.get();

      if (attendanceDoc.exists) {
        final data = attendanceDoc.data() ?? {};
        final mode = data["mode"] ?? "unmarked";

        if (mode != "unmarked") {
          // ✅ Fetch present students
          final recordsSnapshot = await attendanceRef
              .collection("records")
              .where("status", isEqualTo: "present")
              .get();

          final presentStudents = {
            for (var doc in recordsSnapshot.docs)
              doc["studentId"] as String: true,
          };

          // ✅ Fetch stored lessonTopic if available
          LessonTopic? lessonTopic;
          if (data["lessonTopic"] != null) {
            final lt = data["lessonTopic"] as Map<String, dynamic>;
            lessonTopic = LessonTopic(
              number: lt["number"] ?? 0,
              name: lt["name"] ?? "",
              isCompleted: lt["isCompleted"] ?? false,
              dateOfCompletion: lt["dateOfCompletion"]?.toString(),
            );
          }

          return Right(
            AttendanceCheckResult(
              attendanceId: attendanceId,
              alreadyTaken: true,
              presentStudents: presentStudents,
              lessonTopic: lessonTopic,
            ),
          );
        } else {
          // Exists but unmarked
          return Right(
            AttendanceCheckResult(
              attendanceId: attendanceId,
              alreadyTaken: false,
              lessonTopic: null,
            ),
          );
        }
      }

      // ✅ Create new attendance if no document exists
      final createResult = await createAttendanceBatch(classData, students);
      return createResult.fold(
            (failure) => Left(failure),
            (newId) =>
            Right(
              AttendanceCheckResult(
                attendanceId: newId,
                alreadyTaken: false,
                lessonTopic: null,
              ),
            ),
      );
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, String>> createAttendanceBatch(
      ClassSession classData,
      List<Student> students,) async {
    try {
      if (students.isEmpty) {
        return Left(AppFailure(message: "No students found for this section"));
      }

      final uniquePart = classData.classId.replaceFirst("CLS-", "");
      final attendanceId = "ATD-$uniquePart";
      final attendanceRef = firestore
          .collection("attendance")
          .doc(attendanceId);
      final batch = firestore.batch();

      batch.set(attendanceRef, {
        "attendanceId": attendanceId,
        "classId": classData.classId,
        "subjectId": classData.subjectId,
        "sectionId": classData.sectionId,
        "semesterNo": classData.semesterNo,
        "teacherId": classData.teacherId,
        "date": DateTime.now(),
        "mode": "unmarked",
        "lessonTopic": null,
        "createdAt": FieldValue.serverTimestamp(),
      });

      for (final student in students) {
        final recordRef = attendanceRef.collection("records").doc(student.id);
        batch.set(recordRef, {
          "studentId": student.id,
          "status": "absent",
          "markedBy": null,
          "mode": null,
          "timestamp": null,
        });
      }

      final classRef = firestore
          .collection("classSessions")
          .doc(classData.classId);
      batch.update(classRef, {"attendanceId": attendanceId});

      await batch.commit();
      return Right(attendanceId);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markAttendanceManual(String attendanceId,
      Map<String, bool> selectedStudents,
      String mode,
      String teacherId,
      LessonTopic lessonTopic,
      String sectionId,) async {
    try {
      final attendanceRef = firestore
          .collection("attendance")
          .doc(attendanceId);
      final batch = firestore.batch();

      final lessonRef = firestore
          .collection("teachers")
          .doc(teacherId)
          .collection("lessonPlans")
          .doc(sectionId);

      // ✅ 1. Update attendance records
      for (final entry in selectedStudents.entries) {
        final recordRef = attendanceRef.collection("records").doc(entry.key);
        batch.update(recordRef, {
          "status": entry.value ? "present" : "absent",
          "markedBy": teacherId,
          "mode": mode.toLowerCase(),
          "timestamp": DateTime.now(),
        });
      }

      // ✅ 2. Save lesson topic info inside attendance doc
      batch.update(attendanceRef, {
        "mode": mode.toLowerCase(),
        "modifiedAt": DateTime.now(),
        "lessonTopic": {
          "number": lessonTopic.number,
          "name": lessonTopic.name,
          "isCompleted": true,
          "dateOfCompletion":
          lessonTopic.dateOfCompletion ??
              DateTime.now(), // store string or server TS
        },
      });

      // ✅ 3. Update lesson plan → mark topic as completed
      final lessonSnap = await lessonRef.get();
      if (lessonSnap.exists) {
        final data = lessonSnap.data() as Map<String, dynamic>;

        List<dynamic> topics = List.from(data["topics"] ?? []);

        final updatedTopics = topics.map((t) {
          if (t["number"] == lessonTopic.number) {
            return {
              ...t,
              "isCompleted": true,
              "dateOfCompletion": DateTime.now(),
            };
          }
          return t;
        }).toList();

        batch.update(lessonRef, {"topics": updatedTopics});
      }

      // ✅ 4. Commit batch
      await batch.commit();
      return const Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Map<String, bool>>> getAttendanceDataById(
      String attendanceId,) async {
    try {
      final recordsSnapshot = await firestore
          .collection("attendance")
          .doc(attendanceId)
          .collection("records")
          .where("status", isEqualTo: "present")
          .get();

      if (recordsSnapshot.docs.isEmpty) {
        return Right({});
      }

      final presentStudents = {
        for (var doc in recordsSnapshot.docs) doc["studentId"] as String: true,
      };
      return Right(presentStudents);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteAttendanceById(String attendanceId,
      String classId,
      String lessonNumber,
      String sectionId,
      String teacherId,) async {
    try {
      // 1. Delete attendance
      await firestore.collection("attendance").doc(attendanceId).delete();

      // 2. Reset attendanceId in classSessions
      await firestore.collection("classSessions").doc(classId).update({
        "attendanceId": null,
      });

      // 3. Update lessonPlan -> topics in teacher's collection
      final lessonPlanRef = firestore
          .collection("teachers")
          .doc(teacherId)
          .collection("lessonPlans")
          .doc(sectionId);

      final docSnapshot = await lessonPlanRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final topics = List<Map<String, dynamic>>.from(data["topics"]);

        final updatedTopics = topics.map((topic) {
          if (topic["number"] == lessonNumber) {
            return {
              ...topic,
              "isCompleted": false,
              "dateOfCompletion": null,
            };
          }
          return topic;
        }).toList();

        await lessonPlanRef.update({"topics": updatedTopics});
      }

      return Right(unit);
    } catch (e) {
      return Left(AppFailure(message: e.toString()));
    }
  }
}
