import 'dart:typed_data';
import 'package:cats_vs_dogs/models/conerters/Uint8List.converter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prediction.g.dart';

@HiveType(typeId: 1)
@DataRepository([])
@JsonSerializable()
class Prediction extends DataModel<Prediction> {
  static const cat = 'cat';
  static const dog = 'dog';

  @override
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String prediction;

  @HiveField(2)
  final int confidence;

  @HiveField(3)
  @Uint8ListConverter()
  final Uint8List image;

  @HiveField(4)
  final String? validPrediction;

  @HiveField(5)
  late DateTime timestamp;

  Prediction({
    required this.id,
    required this.prediction,
    required this.confidence,
    required this.image,
    this.validPrediction,
    DateTime? timestamp,
  }) {
    this.timestamp = timestamp ?? DateTime.now();
  }

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionToJson(this);

  Prediction copyWith({
    String? id,
    String? prediction,
    int? confidence,
    Uint8List? image,
    String? validPrediction,
  }) {
    return Prediction(
      id: id ?? this.id,
      prediction: prediction ?? this.prediction,
      confidence: confidence ?? this.confidence,
      image: image ?? this.image,
      validPrediction: validPrediction ?? this.validPrediction,
    );
  }

  bool get isPredictionCorrect => prediction == validPrediction;
  bool get isPredictionVerified => validPrediction != null;

  String getPredictionText() {
    if (prediction == cat) {
      return 'Cat';
    }
    return 'Dog';
  }

  String getValidPredictionText() {
    if (validPrediction == cat) {
      return 'Cat';
    } else if (validPrediction == dog) {
      return 'Dog';
    }
    return 'Not provided';
  }
}
