import 'dart:convert';
import 'package:collection/collection.dart';
import '../../academic_structure/models/section.dart';
import '../../subjects/models/subject.dart';

class Teacher {
  String teacherId;
  String teacherName;
  String branchId;
  String phoneNumber;
  String designation;
  String dateOfJoining;
  String gender;
  String role;
  String email;
  String profilePhotoUrl;
  List<Subject> subjects;
  List<Section> assignedClasses;
  String totalPoints;
  String? deviceToken;

  Teacher({
    required this.teacherId,
    required this.teacherName,
    required this.branchId,
    required this.phoneNumber,
    required this.designation,
    required this.dateOfJoining,
    required this.gender,
    required this.role,
    required this.email,
    required this.profilePhotoUrl,
    required this.subjects,
    required this.assignedClasses,
    required this.totalPoints,
    this.deviceToken,
  });

  Teacher copyWith({
    String? teacherId,
    String? teacherName,
    String? branchId,
    String? phoneNumber,
    String? designation,
    String? dateOfJoining,
    String? gender,
    String? role,
    String? email,
    String? profilePhotoUrl,
    List<Subject>? subjects,
    List<Section>? assignedClasses,
    String? totalPoints,
    String? deviceToken,
  }) {
    return Teacher(
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      branchId: branchId ?? this.branchId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      designation: designation ?? this.designation,
      dateOfJoining: dateOfJoining ?? this.dateOfJoining,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      subjects: subjects ?? this.subjects,
      assignedClasses: assignedClasses ?? this.assignedClasses,
      totalPoints: totalPoints ?? this.totalPoints,
      deviceToken: deviceToken ?? this.deviceToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'teacherName': teacherName,
      'branchId': branchId,
      'phoneNumber': phoneNumber,
      'designation': designation,
      'dateOfJoining': dateOfJoining,
      'gender': gender,
      'role': role,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'subjects': subjects.map((x) => x.toMap()).toList(),
      'assignedClasses': assignedClasses.map((x) => x.toMap()).toList(),
      'totalPoints': totalPoints,
      'deviceToken': deviceToken,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      teacherId: map['teacherId'] ?? '',
      teacherName: map['teacherName'] ?? '',
      branchId: map['branchId'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      designation: map['designation'] ?? '',
      dateOfJoining: map['dateOfJoining'] ?? '',
      gender: map['gender'] ?? '',
      role: map['role'] ?? '',
      email: map['email'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
      subjects: (map['subjects'] as List<dynamic>?)
          ?.map((x) => Subject.fromMap(x as Map<String, dynamic>))
          .toList() ??
          [],
      assignedClasses: (map['assignedClasses'] as List<dynamic>?)
          ?.map((x) => Section.fromMap(x as Map<String, dynamic>))
          .toList() ??
          [],
      totalPoints: map['totalPoints'] ?? '0',
      deviceToken: map['deviceToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Teacher(teacherId: $teacherId, teacherName: $teacherName, branchId: $branchId, phoneNumber: $phoneNumber, designation: $designation, dateOfJoining: $dateOfJoining, gender: $gender, role: $role, email: $email, profilePhotoUrl: $profilePhotoUrl, subjects: $subjects, assignedClasses: $assignedClasses, totalPoints: $totalPoints, deviceToken: $deviceToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Teacher &&
        other.teacherId == teacherId &&
        other.teacherName == teacherName &&
        other.branchId == branchId &&
        other.phoneNumber == phoneNumber &&
        other.designation == designation &&
        other.dateOfJoining == dateOfJoining &&
        other.gender == gender &&
        other.role == role &&
        other.email == email &&
        other.profilePhotoUrl == profilePhotoUrl &&
        const DeepCollectionEquality().equals(other.subjects, subjects) &&
        const DeepCollectionEquality().equals(other.assignedClasses, assignedClasses) &&
        other.totalPoints == totalPoints &&
        other.deviceToken == deviceToken;
  }

  @override
  int get hashCode {
    return teacherId.hashCode ^
    teacherName.hashCode ^
    branchId.hashCode ^
    phoneNumber.hashCode ^
    designation.hashCode ^
    dateOfJoining.hashCode ^
    gender.hashCode ^
    role.hashCode ^
    email.hashCode ^
    profilePhotoUrl.hashCode ^
    subjects.hashCode ^
    assignedClasses.hashCode ^
    totalPoints.hashCode ^
    deviceToken.hashCode;
  }
}
