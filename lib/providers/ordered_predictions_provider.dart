import 'package:cats_vs_dogs/main.data.dart';
import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ordered_predictions_provider.g.dart';

@riverpod
Stream<List<Prediction>> orderedPredictions(OrderedPredictionsRef ref) async* {
  final data = ref.predictions.watchAll(remote: false);
  if (data.hasModel) {
    List<Prediction> result = [...data.model];
    result.sort((p1, p2) {
      return p2.timestamp.compareTo(p1.timestamp);
    });
    yield result;
  }
}
