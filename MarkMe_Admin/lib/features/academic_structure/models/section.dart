import 'dart:convert';

import 'package:collection/collection.dart' show DeepCollectionEquality;

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Section {
  final String sectionId;
  final String sectionName;
  final String batchId;
  final String branchId;
  final List<String> studentIds;
  Section({
    required this.sectionId,
    required this.sectionName,
    required this.batchId,
    required this.branchId,
    required this.studentIds,
  });

  Section copyWith({
    String? sectionId,
    String? sectionName,
    String? batchId,
    String? branchId,
    List<String>? studentIds,
  }) {
    return Section(
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
      studentIds: studentIds ?? this.studentIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sectionId': sectionId,
      'sectionName': sectionName,
      'batchId': batchId,
      'branchId': branchId,
      'studentIds': studentIds,
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      sectionId: map['sectionId'] as String,
      sectionName: map['sectionName'] as String,
      batchId: map['batchId'] as String,
      branchId: map['branchId'] as String,
      studentIds: List<String>.from(map['studentIds'] as List),
    );
  }


  String toJson() => json.encode(toMap());

  factory Section.fromJson(String source) => Section.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Section(sectionId: $sectionId, sectionName: $sectionName, batchId: $batchId, branchId: $branchId, studentIds: $studentIds)';
  }

  @override
  bool operator ==(covariant Section other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return
      other.sectionId == sectionId &&
          other.sectionName == sectionName &&
          other.batchId == batchId &&
          other.branchId == branchId &&
          listEquals(other.studentIds, studentIds);
  }

  @override
  int get hashCode {
    return sectionId.hashCode ^
    sectionName.hashCode ^
    batchId.hashCode ^
    branchId.hashCode ^
    studentIds.hashCode;
  }
}
