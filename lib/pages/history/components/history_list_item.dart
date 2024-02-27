import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:cats_vs_dogs/pages/prediction-details/prediction-details.page.dart';
import 'package:flutter/material.dart';

class HistoryListItem extends StatelessWidget {
  final Prediction prediction;

  const HistoryListItem({
    Key? key,
    required this.prediction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return PredictionDetailsPage(prediction: prediction);
          },
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.memory(
              prediction.image,
              width: 90,
              height: 90,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Prediction: It is ${prediction.confidence}% ${prediction.getPredictionText()}'),
                  Text('Actual: ${prediction.getValidPredictionText()}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
