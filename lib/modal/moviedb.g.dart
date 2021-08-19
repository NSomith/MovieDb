// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moviedb.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDbAdapter extends TypeAdapter<MovieDb> {
  @override
  final int typeId = 0;

  @override
  MovieDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDb()
      ..name = fields[0] as String
      ..des = fields[1] as String
      ..img = fields[2] as Uint8List;
  }

  @override
  void write(BinaryWriter writer, MovieDb obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.des)
      ..writeByte(2)
      ..write(obj.img);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
