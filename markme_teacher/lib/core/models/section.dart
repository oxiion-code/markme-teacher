// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

part 'section.g.dart';

@HiveType(typeId: 3) // ⚡ Give unique typeId for this model
class Section {
  @HiveField(0)
  final String sectionId; // e.g. "cse_2022_2026_CSE I"

  @HiveField(1)
  final String sectionName; // e.g. "CSE I"

  @HiveField(2)
  final String batchId; // e.g. "cse_2022_2026"

  @HiveField(3)
  final String branchId; // e.g. "cse"

  @HiveField(4)
  final List<String> studentIds; // list of enrolled students

  @HiveField(5)
  final String? proctorId;

  @HiveField(6)
  final String? defaultRoom;

  @HiveField(7)
  final String? hodId;

  @HiveField(8)
  final String? hodName;

  @HiveField(9)
  final String? proctorName;

  @HiveField(10)
  final String courseId;

  @HiveField(11)
  final String currentSemesterId;

  @HiveField(12)
  final int currentSemesterNumber;

  Section({
    required this.sectionId,
    required this.sectionName,
    required this.batchId,
    required this.branchId,
    required this.studentIds,
    this.proctorId,
    this.defaultRoom,
    this.hodId,
    this.hodName,
    this.proctorName,
    required this.courseId,
    required this.currentSemesterId,
    required this.currentSemesterNumber,
  });

  Section copyWith({
    String? sectionId,
    String? sectionName,
    String? batchId,
    String? branchId,
    List<String>? studentIds,
    String? proctorId,
    String? defaultRoom,
    String? hodId,
    String? hodName,
    String? proctorName,
    String? courseId,
    String? currentSemesterId,
    int? currentSemesterNumber,
  }) {
    return Section(
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      studentIds: studentIds ?? this.studentIds,
      proctorId: proctorId ?? this.proctorId,
      defaultRoom: defaultRoom ?? this.defaultRoom,
      hodId: hodId ?? this.hodId,
      hodName: hodName ?? this.hodName,
      proctorName: proctorName ?? this.proctorName,
      courseId: courseId ?? this.courseId,
      currentSemesterId: currentSemesterId ?? this.currentSemesterId,
      currentSemesterNumber:
      currentSemesterNumber ?? this.currentSemesterNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sectionId': sectionId,
      'sectionName': sectionName,
      'batchId': batchId,
      'branchId': branchId,
      'studentIds': studentIds,
      'proctorId': proctorId,
      'defaultRoom': defaultRoom,
      'hodId': hodId,
      'hodName': hodName,
      'proctorName': proctorName,
      'courseId': courseId,
      'currentSemesterId': currentSemesterId,
      'currentSemesterNumber': currentSemesterNumber,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      sectionId: map['sectionId'] as String,
      sectionName: map['sectionName'] as String,
      batchId: map['batchId'] as String,
      branchId: map['branchId'] as String,
      studentIds: List<String>.from(map['studentIds'] ?? []),
      proctorId: map['proctorId'],
      defaultRoom: map['defaultRoom'],
      hodId: map['hodId'],
      hodName: map['hodName'],
      proctorName: map['proctorName'],
      courseId: map['courseId'] as String,
      currentSemesterId: map['currentSemesterId'] as String,
      currentSemesterNumber: map['currentSemesterNumber'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Section.fromJson(String source) =>
      Section.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Section(sectionId: $sectionId, sectionName: $sectionName, batchId: $batchId, branchId: $branchId, studentIds: $studentIds, proctorId: $proctorId, defaultRoom: $defaultRoom, hodId: $hodId, hodName: $hodName, proctorName: $proctorName, courseId: $courseId, currentSemesterId: $currentSemesterId, currentSemesterNumber: $currentSemesterNumber)';
  }

  @override
  bool operator ==(covariant Section other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.sectionId == sectionId &&
        other.sectionName == sectionName &&
        other.batchId == batchId &&
        other.branchId == branchId &&
        listEquals(other.studentIds, studentIds) &&
        other.proctorId == proctorId &&
        other.defaultRoom == defaultRoom &&
        other.hodId == hodId &&
        other.hodName == hodName &&
        other.proctorName == proctorName &&
        other.courseId == courseId &&
        other.currentSemesterId == currentSemesterId &&
        other.currentSemesterNumber == currentSemesterNumber;
  }

  @override
  int get hashCode {
    return sectionId.hashCode ^
    sectionName.hashCode ^
    batchId.hashCode ^
    branchId.hashCode ^
    studentIds.hashCode ^
    proctorId.hashCode ^
    defaultRoom.hashCode ^
    hodId.hashCode ^
    hodName.hashCode ^
    proctorName.hashCode ^
    courseId.hashCode ^
    currentSemesterId.hashCode ^
    currentSemesterNumber.hashCode;
  }
}
