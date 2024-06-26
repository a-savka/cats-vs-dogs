import 'dart:typed_data';

import 'package:cats_vs_dogs/components/pick_image_button.dart';
import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:cats_vs_dogs/pages/history/history.page.dart';
import 'package:cats_vs_dogs/pages/options/options.page.dart';
import 'package:cats_vs_dogs/pages/prediction-details/prediction-details.page.dart';
import 'package:cats_vs_dogs/pages/statistics/statistics.page.dart';
import 'package:cats_vs_dogs/providers/ordered_predictions_provider.dart';
import 'package:cats_vs_dogs/services/cuid.service.dart';
import 'package:cats_vs_dogs/services/filesystem.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Interpreter _interpreter;
  late bool isLoading;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    isLoading = false;
    super.initState();
    _loadModel();
  }

  void _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
        'assets/models/cats_with_dogs_advanced.tflite');
  }

  Future<void> _predictImage(String image_path) async {
    ByteData imageData = await rootBundle.load(image_path);
    img.Image? my_image = img.decodeImage(imageData.buffer.asUint8List())!;
    if (my_image.isNotEmpty) {
      _convertAndRunCNN(my_image, image_path);
    }
  }

  Prediction _convertAndRunCNN(img.Image myImage, String imageName) {
    final destImage = img.copyResize(myImage, width: 180, height: 180);
    final inputTensor = [_toImageMatrix(destImage)];
    final outputTensor = Float32List(1 * 1).reshape([1, 1]);
    _interpreter.run(inputTensor, outputTensor);
    final result = (outputTensor[0][0]);
    final jpgImage = img.encodeJpg(destImage);
    final Prediction prediction = Prediction(
      id: ref.read(cuidServiceProvider).newCuid(),
      prediction: result > 0.5 ? Prediction.dog : Prediction.cat,
      confidence: ((0.5 - result).abs() * 100 + 50).toInt(),
      image: jpgImage,
    );
    prediction.saveLocal();
    return prediction;
  }

  void _pickImage(XFile imageFile) async {
    setState(() {
      isLoading = true;
    });
    final imageData = await imageFile.readAsBytes();
    final decoded = img.decodeImage(imageData.buffer.asUint8List())!;
    if (decoded.isNotEmpty) {
      final prediction = _convertAndRunCNN(decoded, imageFile.path);
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return PredictionDetailsPage(
              prediction: prediction,
            );
          },
        ));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  List<List<List<num>>> _toImageMatrix(img.Image imageInput) {
    final imageMatrix = List.generate(
      imageInput.height,
      (y) => List.generate(
        imageInput.width,
        (x) {
          final pixel = imageInput.getPixel(x, y);
          return [
            _normilizeChannel(pixel.r),
            _normilizeChannel(pixel.g),
            _normilizeChannel(pixel.b)
          ];
        },
      ),
    );
    return imageMatrix;
  }

  num _normilizeChannel(num value) {
    return value;
  }

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(40),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/images/dog_cat.svg',
                          width: 250,
                          height: 250,
                          color: Theme.of(context).primaryColor.withAlpha(140),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        PickImageButton(
                          buttonStyle: buttonStyle,
                          onChoose: (XFile file) {
                            _pickImage(file);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const HistoryPage();
                              },
                            ));
                          },
                          child: const Text('History'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const StatisticsPage();
                              },
                            ));
                          },
                          child: const Text('Statistics'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const OptionsPage();
                              },
                            ));
                          },
                          child: const Text('Options'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
