// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 2;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      id: fields[0] as String,
      phoneNumber: fields[1] as String,
      profilePhotoUrl: fields[2] as String,
      rollNo: fields[3] as String,
      regdNo: fields[4] as String,
      name: fields[5] as String,
      branchId: fields[6] as String,
      sectionId: fields[7] as String,
      group: fields[8] as String,
      fatherName: fields[9] as String,
      motherName: fields[10] as String,
      studentMobileNo: fields[11] as String,
      fatherMobileNo: fields[12] as String,
      motherMobileNo: fields[13] as String,
      email: fields[14] as String,
      dob: fields[15] as String,
      category: fields[16] as String,
      admissionDate: fields[17] as String,
      sex: fields[18] as String,
      deviceToken: fields[19] as String,
      batchId: fields[20] as String,
      courseId: fields[21] as String,
      hostelAddress: fields[22] as HostelAddress,
      normalAddress: fields[23] as NormalAddress,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.profilePhotoUrl)
      ..writeByte(3)
      ..write(obj.rollNo)
      ..writeByte(4)
      ..write(obj.regdNo)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.branchId)
      ..writeByte(7)
      ..write(obj.sectionId)
      ..writeByte(8)
      ..write(obj.group)
      ..writeByte(9)
      ..write(obj.fatherName)
      ..writeByte(10)
      ..write(obj.motherName)
      ..writeByte(11)
      ..write(obj.studentMobileNo)
      ..writeByte(12)
      ..write(obj.fatherMobileNo)
      ..writeByte(13)
      ..write(obj.motherMobileNo)
      ..writeByte(14)
      ..write(obj.email)
      ..writeByte(15)
      ..write(obj.dob)
      ..writeByte(16)
      ..write(obj.category)
      ..writeByte(17)
      ..write(obj.admissionDate)
      ..writeByte(18)
      ..write(obj.sex)
      ..writeByte(19)
      ..write(obj.deviceToken)
      ..writeByte(20)
      ..write(obj.batchId)
      ..writeByte(21)
      ..write(obj.courseId)
      ..writeByte(22)
      ..write(obj.hostelAddress)
      ..writeByte(23)
      ..write(obj.normalAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HostelAddressAdapter extends TypeAdapter<HostelAddress> {
  @override
  final int typeId = 3;

  @override
  HostelAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HostelAddress(
      hostel: fields[0] as String,
      block: fields[1] as String,
      roomNo: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HostelAddress obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.hostel)
      ..writeByte(1)
      ..write(obj.block)
      ..writeByte(2)
      ..write(obj.roomNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HostelAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NormalAddressAdapter extends TypeAdapter<NormalAddress> {
  @override
  final int typeId = 4;

  @override
  NormalAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NormalAddress(
      atPo: fields[0] as String,
      cityVillage: fields[1] as String,
      dist: fields[2] as String,
      state: fields[3] as String,
      pin: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NormalAddress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.atPo)
      ..writeByte(1)
      ..write(obj.cityVillage)
      ..writeByte(2)
      ..write(obj.dist)
      ..writeByte(3)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.pin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NormalAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
