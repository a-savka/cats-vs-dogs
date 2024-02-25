import 'package:cats_vs_dogs/components/confirm_prediction.dart';
import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;

class ShowPrediction extends HookConsumerWidget {
  final Prediction prediction;
  const ShowPrediction({
    Key? key,
    required this.prediction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final imgData = img.decodePng(prediction.image)!.toUint8List();
    // print(imgData);
    // ByteData imageData = await rootBundle.load(assets/images/cat.1501.jpg);
    // img.Image? my_image = img.decodeImage(imageData.buffer.asUint8List())!;
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
            prediction.isPredictionCorrect == null
                ? const ConfirmPrediction()
                : const Text('Prediction made'),
            const SizedBox(
              height: 10,
            ),
          ],
          // child: FutureBuilder(
          //   future: rootBundle.load('assets/images/cat.1501.jpg'),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       final imageData = snapshot.data;
          //       if (imageData != null) {
          //         img.Image? my_image = img.copyResize(
          //             img.decodeImage(
          //               imageData.buffer.asUint8List(),
          //             )!,
          //             width: 180,
          //             height: 180);
          //         if (my_image != null) {
          //           return Image.memory(img.encodeJpg(my_image));
          //         }
          //         return const Text('Failed to decode data');
          //       }
          //       return const Text('Failed to load data');
          //     }
          //     return const Text('Loading');
          //   },
          // ),
        ),
      ),
    );
  }
}
