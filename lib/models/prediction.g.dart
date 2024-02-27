// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// RepositoryGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, duplicate_ignore

mixin $PredictionLocalAdapter on LocalAdapter<Prediction> {
  static final Map<String, RelationshipMeta> _kPredictionRelationshipMetas = {};

  @override
  Map<String, RelationshipMeta> get relationshipMetas =>
      _kPredictionRelationshipMetas;

  @override
  Prediction deserialize(map) {
    map = transformDeserialize(map);
    return Prediction.fromJson(map);
  }

  @override
  Map<String, dynamic> serialize(model, {bool withRelationships = true}) {
    final map = model.toJson();
    return transformSerialize(map, withRelationships: withRelationships);
  }
}

final _predictionsFinders = <String, dynamic>{};

// ignore: must_be_immutable
class $PredictionHiveLocalAdapter = HiveLocalAdapter<Prediction>
    with $PredictionLocalAdapter;

class $PredictionRemoteAdapter = RemoteAdapter<Prediction> with NothingMixin;

final internalPredictionsRemoteAdapterProvider =
    Provider<RemoteAdapter<Prediction>>((ref) => $PredictionRemoteAdapter(
        $PredictionHiveLocalAdapter(ref), InternalHolder(_predictionsFinders)));

final predictionsRepositoryProvider =
    Provider<Repository<Prediction>>((ref) => Repository<Prediction>(ref));

extension PredictionDataRepositoryX on Repository<Prediction> {}

extension PredictionRelationshipGraphNodeX
    on RelationshipGraphNode<Prediction> {}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PredictionAdapter extends TypeAdapter<Prediction> {
  @override
  final int typeId = 1;

  @override
  Prediction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prediction(
      id: fields[0] as String,
      prediction: fields[1] as String,
      confidence: fields[2] as int,
      image: fields[3] as Uint8List,
      validPrediction: fields[4] as String?,
      timestamp: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Prediction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.prediction)
      ..writeByte(2)
      ..write(obj.confidence)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.validPrediction)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prediction _$PredictionFromJson(Map<String, dynamic> json) => Prediction(
      id: json['id'] as String,
      prediction: json['prediction'] as String,
      confidence: json['confidence'] as int,
      image: const Uint8ListConverter().fromJson(json['image'] as List<int>),
      validPrediction: json['validPrediction'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'prediction': instance.prediction,
      'confidence': instance.confidence,
      'image': const Uint8ListConverter().toJson(instance.image),
      'validPrediction': instance.validPrediction,
      'timestamp': instance.timestamp.toIso8601String(),
    };
