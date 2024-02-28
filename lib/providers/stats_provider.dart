import 'package:cats_vs_dogs/main.data.dart';
import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:cats_vs_dogs/models/stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_provider.g.dart';

@riverpod
Stream<Stats> stats(StatsRef ref) async* {
  final data = ref.predictions.watchAll(remote: false);
  if (data.hasModel) {
    int confirmed = 0;
    int correct = 0;
    for (Prediction prediction in data.model) {
      if (prediction.isPredictionVerified) {
        confirmed++;
        if (prediction.isPredictionCorrect) {
          correct++;
        }
      }
    }
    yield Stats(
      total: data.model.length,
      correct: correct,
      confirmed: confirmed,
    );
  }
}
