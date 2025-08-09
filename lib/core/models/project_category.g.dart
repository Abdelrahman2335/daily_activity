// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectCategoryModelAdapter extends TypeAdapter<ProjectCategoryModel> {
  @override
  final int typeId = 4;

  @override
  ProjectCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectCategoryModel(
      title: fields[0] as String,
      colorValue: fields[1] as int,
      icon: fields[2] as IconData,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectCategoryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.colorValue)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectCategoryAdapter extends TypeAdapter<ProjectCategory> {
  @override
  final int typeId = 1;

  @override
  ProjectCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectCategory.work;
      case 1:
        return ProjectCategory.personal;
      case 2:
        return ProjectCategory.dailyStudy;
      case 3:
        return ProjectCategory.healthFitness;
      case 4:
        return ProjectCategory.finance;
      case 5:
        return ProjectCategory.shopping;
      case 6:
        return ProjectCategory.travel;
      case 7:
        return ProjectCategory.sideProjects;
      case 8:
        return ProjectCategory.socialEvents;
      default:
        return ProjectCategory.work;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectCategory obj) {
    switch (obj) {
      case ProjectCategory.work:
        writer.writeByte(0);
        break;
      case ProjectCategory.personal:
        writer.writeByte(1);
        break;
      case ProjectCategory.dailyStudy:
        writer.writeByte(2);
        break;
      case ProjectCategory.healthFitness:
        writer.writeByte(3);
        break;
      case ProjectCategory.finance:
        writer.writeByte(4);
        break;
      case ProjectCategory.shopping:
        writer.writeByte(5);
        break;
      case ProjectCategory.travel:
        writer.writeByte(6);
        break;
      case ProjectCategory.sideProjects:
        writer.writeByte(7);
        break;
      case ProjectCategory.socialEvents:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
