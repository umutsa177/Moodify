// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_video.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedVideoAdapter extends TypeAdapter<SavedVideo> {
  @override
  final typeId = 0;

  @override
  SavedVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedVideo(
      videoId: fields[0] as String,
      title: fields[1] as String,
      thumbnail: fields[2] as String,
      duration: fields[3] as String,
      videoUrl: fields[4] as String,
      savedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedVideo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.videoId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnail)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.videoUrl)
      ..writeByte(5)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
