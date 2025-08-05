import 'dart:convert';

class Subject {
  final String subjectId;
  final String subjectName;
  final String batchId;
  final String branchId;
  Subject({
    required this.subjectId,
    required this.subjectName,
    required this.batchId,
    required this.branchId,
  });

  Subject copyWith({
    String? subjectId,
    String? subjectName,
    String? batchId,
    String? branchId,
  }) {
    return Subject(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      batchId: batchId ?? this.batchId,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subjectId': subjectId,
      'subjectName': subjectName,
      'batchId': batchId,
      'branchId': branchId,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      subjectId: map['subjectId'] ?? "",
      subjectName: map['subjectName'] ?? "",
      batchId: map['batchId'] ?? "",
      branchId: map['branchId'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) => Subject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Subject(subjectId: $subjectId, subjectName: $subjectName, batchId: $batchId, branchId: $branchId)';
  }

  @override
  bool operator ==(covariant Subject other) {
    if (identical(this, other)) return true;

    return
      other.subjectId == subjectId &&
          other.subjectName == subjectName &&
          other.batchId == batchId &&
          other.branchId == branchId;
  }

  @override
  int get hashCode {
    return subjectId.hashCode ^
    subjectName.hashCode ^
    batchId.hashCode ^
    branchId.hashCode;
  }
}
