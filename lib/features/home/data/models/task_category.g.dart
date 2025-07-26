// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskCategoryAdapter extends TypeAdapter<TaskCategory> {
  @override
  final int typeId = 1;

  @override
  TaskCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskCategory.work;
      case 1:
        return TaskCategory.personal;
      case 2:
        return TaskCategory.dailyStudy;
      case 3:
        return TaskCategory.healthFitness;
      case 4:
        return TaskCategory.finance;
      case 5:
        return TaskCategory.shopping;
      case 6:
        return TaskCategory.travel;
      case 7:
        return TaskCategory.sideProjects;
      case 8:
        return TaskCategory.socialEvents;
      default:
        return TaskCategory.work;
    }
  }

  @override
  void write(BinaryWriter writer, TaskCategory obj) {
    switch (obj) {
      case TaskCategory.work:
        writer.writeByte(0);
        break;
      case TaskCategory.personal:
        writer.writeByte(1);
        break;
      case TaskCategory.dailyStudy:
        writer.writeByte(2);
        break;
      case TaskCategory.healthFitness:
        writer.writeByte(3);
        break;
      case TaskCategory.finance:
        writer.writeByte(4);
        break;
      case TaskCategory.shopping:
        writer.writeByte(5);
        break;
      case TaskCategory.travel:
        writer.writeByte(6);
        break;
      case TaskCategory.sideProjects:
        writer.writeByte(7);
        break;
      case TaskCategory.socialEvents:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
