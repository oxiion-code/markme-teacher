// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SectionAdapter extends TypeAdapter<Section> {
  @override
  final int typeId = 3;

  @override
  Section read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Section(
      sectionId: fields[0] as String,
      sectionName: fields[1] as String,
      batchId: fields[2] as String,
      branchId: fields[3] as String,
      studentIds: (fields[4] as List).cast<String>(),
      proctorId: fields[5] as String?,
      defaultRoom: fields[6] as String?,
      hodId: fields[7] as String?,
      hodName: fields[8] as String?,
      proctorName: fields[9] as String?,
      courseId: fields[10] as String,
      currentSemesterId: fields[11] as String,
      currentSemesterNumber: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Section obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.sectionId)
      ..writeByte(1)
      ..write(obj.sectionName)
      ..writeByte(2)
      ..write(obj.batchId)
      ..writeByte(3)
      ..write(obj.branchId)
      ..writeByte(4)
      ..write(obj.studentIds)
      ..writeByte(5)
      ..write(obj.proctorId)
      ..writeByte(6)
      ..write(obj.defaultRoom)
      ..writeByte(7)
      ..write(obj.hodId)
      ..writeByte(8)
      ..write(obj.hodName)
      ..writeByte(9)
      ..write(obj.proctorName)
      ..writeByte(10)
      ..write(obj.courseId)
      ..writeByte(11)
      ..write(obj.currentSemesterId)
      ..writeByte(12)
      ..write(obj.currentSemesterNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
