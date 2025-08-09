import 'package:hive/hive.dart';

class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final int typeId = 6; // Use a unique typeId

  @override
  DateTime read(BinaryReader reader) {
    final milliseconds = reader.readInt();
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.millisecondsSinceEpoch);
  }
}
