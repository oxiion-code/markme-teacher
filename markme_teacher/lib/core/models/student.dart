import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 2) // unique ID for Student
class Student extends HiveObject {
  @HiveField(0)
  final String id; // Firebase UID

  @HiveField(1)
  final String phoneNumber;

  @HiveField(2)
  final String profilePhotoUrl;

  @HiveField(3)
  final String rollNo;

  @HiveField(4)
  final String regdNo;

  @HiveField(5)
  final String name;

  @HiveField(6)
  final String branchId;

  @HiveField(7)
  final String sectionId;

  @HiveField(8)
  final String group;

  @HiveField(9)
  final String fatherName;

  @HiveField(10)
  final String motherName;

  @HiveField(11)
  final String studentMobileNo;

  @HiveField(12)
  final String fatherMobileNo;

  @HiveField(13)
  final String motherMobileNo;

  @HiveField(14)
  final String email;

  @HiveField(15)
  final String dob;

  @HiveField(16)
  final String category;

  @HiveField(17)
  final String admissionDate;

  @HiveField(18)
  final String sex;

  @HiveField(19)
  final String deviceToken;

  @HiveField(20)
  final String batchId;

  @HiveField(21)
  final String courseId;

  @HiveField(22)
  final HostelAddress hostelAddress;

  @HiveField(23)
  final NormalAddress normalAddress;

  Student({
    required this.id,
    required this.phoneNumber,
    required this.profilePhotoUrl,
    required this.rollNo,
    required this.regdNo,
    required this.name,
    required this.branchId,
    required this.sectionId,
    required this.group,
    required this.fatherName,
    required this.motherName,
    required this.studentMobileNo,
    required this.fatherMobileNo,
    required this.motherMobileNo,
    required this.email,
    required this.dob,
    required this.category,
    required this.admissionDate,
    required this.sex,
    required this.deviceToken,
    required this.batchId,
    required this.courseId,
    required this.hostelAddress,
    required this.normalAddress,
  });

  Student copyWith({
    String? id,
    String? phoneNumber,
    String? profilePhotoUrl,
    String? rollNo,
    String? regdNo,
    String? name,
    String? branchId,
    String? sectionId,
    String? group,
    String? fatherName,
    String? motherName,
    String? studentMobileNo,
    String? fatherMobileNo,
    String? motherMobileNo,
    String? email,
    String? dob,
    String? category,
    String? admissionDate,
    String? sex,
    String? deviceToken,
    String? batchId,
    String? courseId,
    HostelAddress? hostelAddress,
    NormalAddress? normalAddress,
  }) {
    return Student(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      rollNo: rollNo ?? this.rollNo,
      regdNo: regdNo ?? this.regdNo,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      sectionId: sectionId ?? this.sectionId,
      group: group ?? this.group,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      studentMobileNo: studentMobileNo ?? this.studentMobileNo,
      fatherMobileNo: fatherMobileNo ?? this.fatherMobileNo,
      motherMobileNo: motherMobileNo ?? this.motherMobileNo,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      category: category ?? this.category,
      admissionDate: admissionDate ?? this.admissionDate,
      sex: sex ?? this.sex,
      deviceToken: deviceToken ?? this.deviceToken,
      batchId: batchId ?? this.batchId,
      courseId: courseId ?? this.courseId,
      hostelAddress: hostelAddress ?? this.hostelAddress,
      normalAddress: normalAddress ?? this.normalAddress,
    );
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? '',
      rollNo: map['rollNo'] ?? '',
      regdNo: map['regdNo'] ?? '',
      name: map['name'] ?? '',
      branchId: map['branchId'] ?? '',
      sectionId: map['sectionId'] ?? '',
      group: map['group'] ?? '',
      fatherName: map['fatherName'] ?? '',
      motherName: map['motherName'] ?? '',
      studentMobileNo: map['studentMobileNo'] ?? '',
      fatherMobileNo: map['fatherMobileNo'] ?? '',
      motherMobileNo: map['motherMobileNo'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      category: map['category'] ?? '',
      admissionDate: map['admissionDate'] ?? '',
      sex: map['sex'] ?? '',
      deviceToken: map['deviceToken'] ?? '',
      batchId: map['batchId'] ?? '',
      courseId: map['courseId'] ?? '',
      hostelAddress: HostelAddress.fromMap(map['hostelAddress'] ?? {}),
      normalAddress: NormalAddress.fromMap(map['normalAddress'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'profilePhotoUrl': profilePhotoUrl,
      'rollNo': rollNo,
      'regdNo': regdNo,
      'name': name,
      'branchId': branchId,
      'sectionId': sectionId,
      'group': group,
      'fatherName': fatherName,
      'motherName': motherName,
      'studentMobileNo': studentMobileNo,
      'fatherMobileNo': fatherMobileNo,
      'motherMobileNo': motherMobileNo,
      'email': email,
      'dob': dob,
      'category': category,
      'admissionDate': admissionDate,
      'sex': sex,
      'deviceToken': deviceToken,
      'batchId': batchId,
      'courseId': courseId,
      'hostelAddress': hostelAddress.toMap(),
      'normalAddress': normalAddress.toMap(),
    };
  }
}

@HiveType(typeId: 3)
class HostelAddress extends HiveObject {
  @HiveField(0)
  final String hostel;

  @HiveField(1)
  final String block;

  @HiveField(2)
  final String roomNo;

  HostelAddress({
    required this.hostel,
    required this.block,
    required this.roomNo,
  });

  HostelAddress copyWith({String? hostel, String? block, String? roomNo}) {
    return HostelAddress(
      hostel: hostel ?? this.hostel,
      block: block ?? this.block,
      roomNo: roomNo ?? this.roomNo,
    );
  }

  factory HostelAddress.fromMap(Map<String, dynamic> map) {
    return HostelAddress(
      hostel: map['hostel'] ?? '',
      block: map['block'] ?? '',
      roomNo: map['roomNo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'hostel': hostel, 'block': block, 'roomNo': roomNo};
  }
}

@HiveType(typeId: 4)
class NormalAddress extends HiveObject {
  @HiveField(0)
  final String atPo;

  @HiveField(1)
  final String cityVillage;

  @HiveField(2)
  final String dist;

  @HiveField(3)
  final String state;

  @HiveField(4)
  final String pin;

  NormalAddress({
    required this.atPo,
    required this.cityVillage,
    required this.dist,
    required this.state,
    required this.pin,
  });

  NormalAddress copyWith({
    String? atPo,
    String? cityVillage,
    String? dist,
    String? state,
    String? pin,
  }) {
    return NormalAddress(
      atPo: atPo ?? this.atPo,
      cityVillage: cityVillage ?? this.cityVillage,
      dist: dist ?? this.dist,
      state: state ?? this.state,
      pin: pin ?? this.pin,
    );
  }

  factory NormalAddress.fromMap(Map<String, dynamic> map) {
    return NormalAddress(
      atPo: map['atPo'] ?? '',
      cityVillage: map['cityVillage'] ?? '',
      dist: map['dist'] ?? '',
      state: map['state'] ?? '',
      pin: map['pin'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atPo': atPo,
      'cityVillage': cityVillage,
      'dist': dist,
      'state': state,
      'pin': pin,
    };
  }
}
