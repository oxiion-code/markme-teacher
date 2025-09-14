// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 1;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      subjectId: fields[0] as String,
      subjectName: fields[1] as String,
      batchId: fields[2] as String,
      branchId: fields[3] as String,
      subjectCode: fields[4] as String,
      subjectType: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.subjectId)
      ..writeByte(1)
      ..write(obj.subjectName)
      ..writeByte(2)
      ..write(obj.batchId)
      ..writeByte(3)
      ..write(obj.branchId)
      ..writeByte(4)
      ..write(obj.subjectCode)
      ..writeByte(5)
      ..write(obj.subjectType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
