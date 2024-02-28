import 'package:cats_vs_dogs/pages/prediction-details/components/confirm_prediction.dart';
import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PredictionDetailsPage extends HookConsumerWidget {
  final Prediction prediction;
  const PredictionDetailsPage({
    Key? key,
    required this.prediction,
  }) : super(key: key);

  void _onConfirmed(bool isValid) {
    if ((isValid && prediction.prediction == Prediction.cat) ||
        (!isValid && prediction.prediction == Prediction.dog)) {
      prediction.copyWith(validPrediction: Prediction.cat).saveLocal();
    } else {
      prediction.copyWith(validPrediction: Prediction.dog).saveLocal();
      ;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My prediction'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.memory(prediction.image),
            const SizedBox(
              height: 10,
            ),
            Text(
              'I am ${prediction.confidence}% sure that it is ${prediction.getPredictionText()}',
            ),
            const SizedBox(
              height: 20,
            ),
            prediction.validPrediction != prediction.prediction
                ? ConfirmPrediction(onConfirmed: (bool isValid) {
                    _onConfirmed(isValid);
                    Navigator.of(context).pop();
                  })
                : Text('Actual: ${prediction.getValidPredictionText()}'),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
