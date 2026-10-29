// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 0;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as ProjectCategoryModel,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      tasks: (fields[7] as List).cast<TaskModel>(),
      id: fields[0] as String?,
      status: fields[6] as TaskStatus,
      lastModified: fields[8] as DateTime?,
      // Fields 9-11 are nullable; old records that were written before this
      // schema extension simply lack them and read back as null.
      reminderMode: fields[9] as String?,
      customSlots:
          (fields[10] as List?)?.cast<String>(),
      customWeekdays:
          (fields[11] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.tasks)
      ..writeByte(8)
      ..write(obj.lastModified)
      ..writeByte(9)
      ..write(obj.reminderMode)
      ..writeByte(10)
      ..write(obj.customSlots)
      ..writeByte(11)
      ..write(obj.customWeekdays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
