import 'dart:typed_data';

enum PredictionLabel { cat, dog }

class Prediction {
  final String id;
  final PredictionLabel prediction;
  final int confidence;
  final Uint8List image;
  final PredictionLabel? validPrediction;
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

  Prediction copyWith({
    String? id,
    PredictionLabel? prediction,
    int? confidence,
    Uint8List? image,
    PredictionLabel? validPrediction,
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
    if (prediction == PredictionLabel.cat) {
      return 'Cat';
    }
    return 'Dog';
  }
}
