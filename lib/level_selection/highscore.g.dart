// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highscore.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HighScoreAdapter extends TypeAdapter<HighScore> {
  @override
  final int typeId = 0;

  @override
  HighScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HighScore(
      fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HighScore obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
