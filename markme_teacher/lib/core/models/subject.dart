import 'package:hive/hive.dart';

part 'subject.g.dart'; // Needed for Hive type adapter generation

@HiveType(typeId: 1) // <-- Make sure each model has a unique typeId
class Subject extends HiveObject {
  @HiveField(0)
  final String subjectId;

  @HiveField(1)
  final String subjectName;

  @HiveField(2)
  final String batchId;

  @HiveField(3)
  final String branchId;

  @HiveField(4)
  final String subjectCode;

  @HiveField(5)
  final String subjectType; // Added

  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.batchId,
    required this.branchId,
    required this.subjectCode,
    required this.subjectType,
  });

  Subject copyWith({
    String? subjectId,
    String? subjectName,
    String? batchId,
    String? branchId,
    String? subjectCode,
    String? subjectType,
  }) {
    return Subject(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectType: subjectType ?? this.subjectType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'batchId': batchId,
      'branchId': branchId,
      'subjectCode': subjectCode,
      'subjectType': subjectType,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectId: map['subjectId'] ?? "",
      subjectName: map['subjectName'] ?? "",
      batchId: map['batchId'] ?? "",
      branchId: map['branchId'] ?? "",
      subjectCode: map['subjectCode'] ?? "",
      subjectType: map['subjectType'] ?? "",
    );
  }
}
