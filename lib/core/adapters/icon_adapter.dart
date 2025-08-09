import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IconAdapter extends TypeAdapter<IconData> {
  @override
  final int typeId = 5;

  @override
  IconData read(BinaryReader reader) {
    final codePoint = reader.readInt();
    final fontFamily = reader.readString();
    return IconData(codePoint,
        fontFamily: fontFamily.isEmpty ? null : fontFamily);
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    writer.writeInt(obj.codePoint);
    writer.writeString(obj.fontFamily ?? ''); // Handle null fontFamily
  }
}
