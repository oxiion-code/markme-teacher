import 'dart:convert';
import 'lesson_topic.dart';

class LessonPlan {
  String sectionId;
  String subjectId;
  String subjectName;
  List<LessonTopic> topics;
  DateTime createdAt;

  LessonPlan({
    required this.sectionId,
    required this.subjectId,
    required this.subjectName,
    required this.topics,
    required this.createdAt,
  });

  LessonPlan copyWith({
    String? sectionId,
    String? subjectId,
    String? subjectName,
    List<LessonTopic>? topics,
    DateTime? createdAt,
  }) {
    return LessonPlan(
      sectionId: sectionId ?? this.sectionId,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      topics: topics ?? this.topics,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sectionId": sectionId,
      "subjectId": subjectId,
      "subjectName": subjectName,
      "createdAt": createdAt.toIso8601String(),
      "topics": topics.map((t) => t.toMap()).toList(),
    };
  }

  factory LessonPlan.fromMap(Map<String, dynamic> map) {
    return LessonPlan(
      sectionId: map["sectionId"] ?? "",
      subjectId: map["subjectId"] ?? "",
      subjectName: map["subjectName"] ?? "",
      createdAt: DateTime.tryParse(map["createdAt"] ?? "") ?? DateTime.now(),
      topics: (map["topics"] as List<dynamic>?)
          ?.map((e) => LessonTopic.fromMap(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory LessonPlan.fromJson(String source) =>
      LessonPlan.fromMap(json.decode(source));

  @override
  String toString() =>
      "LessonPlan(sectionId: $sectionId, subjectId: $subjectId, subjectName: $subjectName, createdAt: $createdAt, topics: $topics)";
}
