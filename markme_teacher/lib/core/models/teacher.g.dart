// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherAdapter extends TypeAdapter<Teacher> {
  @override
  final int typeId = 0;

  @override
  Teacher read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Teacher(
      teacherId: fields[0] as String,
      teacherName: fields[1] as String,
      branchId: fields[2] as String,
      phoneNumber: fields[3] as String,
      designation: fields[4] as String,
      dateOfJoining: fields[5] as String,
      gender: fields[6] as String,
      role: fields[7] as String,
      email: fields[8] as String,
      profilePhotoUrl: fields[9] as String,
      subjects: (fields[10] as List).cast<Subject>(),
      assignedClasses: (fields[11] as List).cast<String>(),
      totalPoints: fields[12] as String,
      deviceToken: fields[13] as String?,
      liveClassId: fields[14] as String?,
      synced: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Teacher obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.teacherId)
      ..writeByte(1)
      ..write(obj.teacherName)
      ..writeByte(2)
      ..write(obj.branchId)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.designation)
      ..writeByte(5)
      ..write(obj.dateOfJoining)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.role)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.profilePhotoUrl)
      ..writeByte(10)
      ..write(obj.subjects)
      ..writeByte(11)
      ..write(obj.assignedClasses)
      ..writeByte(12)
      ..write(obj.totalPoints)
      ..writeByte(13)
      ..write(obj.deviceToken)
      ..writeByte(14)
      ..write(obj.liveClassId)
      ..writeByte(15)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
