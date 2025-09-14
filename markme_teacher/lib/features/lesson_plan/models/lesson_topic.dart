import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class LessonTopic {
  String number;
  String name;
  bool isCompleted;
  String? dateOfCompletion; // nullable, only set when completed

  LessonTopic({
    required this.number,
    required this.name,
    this.isCompleted = false,
    this.dateOfCompletion,
  });

  LessonTopic copyWith({
    String? number,
    String? name,
    bool? isCompleted,
    String? dateOfCompletion,
  }) {
    return LessonTopic(
      number: number ?? this.number,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
      dateOfCompletion: dateOfCompletion ?? this.dateOfCompletion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "name": name,
      "isCompleted": isCompleted,
      "dateOfCompletion": dateOfCompletion,
    };
  }
  factory LessonTopic.fromMap(Map<String, dynamic> map) {
    return LessonTopic(
      number: map["number"] ?? "",
      name: map["name"] ?? "",
      isCompleted: map["isCompleted"] ?? false,
      dateOfCompletion: map["dateOfCompletion"] != null
          ? (map["dateOfCompletion"] is String
          ? map["dateOfCompletion"]
          : (map["dateOfCompletion"] as Timestamp).toDate().toIso8601String())
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LessonTopic.fromJson(String source) =>
      LessonTopic.fromMap(json.decode(source));

  @override
  String toString() =>
      "LessonTopic(number: $number, name: $name, isCompleted: $isCompleted, dateOfCompletion: $dateOfCompletion)";
}
