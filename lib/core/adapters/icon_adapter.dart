import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IconAdapter extends TypeAdapter<IconData> {
  @override
  final int typeId = 5;

  @override
  IconData read(BinaryReader reader) {
    // Read stored values. Older records may not have fontPackage/matchTextDirection
    final codePoint = reader.readInt();
    String fontFamily = '';
    String fontPackage = '';
    bool matchTextDirection = false;

    try {
      fontFamily = reader.readString();
    } catch (_) {
      // If the older format is used we fall back to null/empty values
      fontFamily = '';
    }

    try {
      // Newer format includes fontPackage
      fontPackage = reader.readString();
    } catch (_) {
      fontPackage = '';
    }

    try {
      // Newer format may also include matchTextDirection as a byte/bool
      // readByte/readBool may be used depending on how it was written; here try readBool
      matchTextDirection = reader.readBool();
    } catch (_) {
      matchTextDirection = false;
    }

    return IconData(codePoint,
        fontFamily: fontFamily.isEmpty ? null : fontFamily,
        fontPackage: fontPackage.isEmpty ? null : fontPackage,
        matchTextDirection: matchTextDirection);
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    writer.writeInt(obj.codePoint);
    writer.writeString(obj.fontFamily ?? ''); // Handle null fontFamily
    writer.writeString(
        obj.fontPackage ?? ''); // Persist package for package icons
    writer.writeBool(obj.matchTextDirection);
  }
}
