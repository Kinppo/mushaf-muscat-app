// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_mark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookMarkAdapter extends TypeAdapter<BookMark> {
  @override
  final int typeId = 0;

  @override
  BookMark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookMark(
      id: fields[0] as String,
      aya: fields[2] as String,
      page: fields[1] as String,
      type: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookMark obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.page)
      ..writeByte(2)
      ..write(obj.aya)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookMarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
