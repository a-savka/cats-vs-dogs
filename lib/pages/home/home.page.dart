import 'dart:typed_data';
import 'package:cats_vs_dogs/components/pick_image_button.dart';
import 'package:cats_vs_dogs/components/show_prediction.dart';
import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:cats_vs_dogs/pages/history/history.page.dart';
import 'package:cats_vs_dogs/services/cuid.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<int> _inputShape = [];
  List<int> _outputShape = [];
  late TensorType _inputType;
  late TensorType _outputType;

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

    setState(() {
      _inputShape = _interpreter.getInputTensor(0).shape;
      _outputShape = _interpreter.getOutputTensor(0).shape;
      _inputType = _interpreter.getInputTensor(0).type;
      _outputType = _interpreter.getOutputTensor(0).type;
    });
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
      // prediction: result > 0.5 ? PredictionLabel.dog : PredictionLabel.cat,
      prediction: result > 0.5 ? Prediction.dog : Prediction.cat,
      confidence: ((0.5 - result).abs() * 100 + 50).toInt(),
      image: jpgImage,
    );
    prediction.saveLocal();
    return prediction;
  }

  void _convertImage() async {
    ByteData imageData = await rootBundle.load('assets/images/cat.1501.jpg');
    img.Image? my_image = img.decodeImage(imageData.buffer.asUint8List())!;
    if (my_image.isNotEmpty) {
      final jpgImage = img.encodePng(my_image);
      final prediction = Prediction(
        id: ref.read(cuidServiceProvider).newCuid(),
        // prediction: PredictionLabel.cat,
        prediction: Prediction.cat,
        confidence: 99,
        image: jpgImage,
      );
      prediction.saveLocal();
      if (mounted) {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return ShowPrediction(
              prediction: prediction,
            );
          },
        ));
      }
      print('created:  ${prediction.id}');
    }
  }

  void _predictAll() async {
    final arrNums = <String>[];
    for (int i = 0; i <= 10; i++) {
      arrNums.add(i.toString().padLeft(2, '0'));
    }
    final files = <String>[
      ...arrNums.map((num) => 'assets/images/cat.15$num.jpg'),
      ...arrNums.map((num) => 'assets/images/dog.15$num.jpg'),
      ...arrNums.getRange(1, 7).map((num) => 'assets/images/cat.$num.jpg'),
    ];
    for (String fileName in files) {
      await _predictImage(fileName);
    }
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
            return ShowPrediction(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Cats Vs Dogs',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('SHAPES:');
                        print(_inputShape);
                        print(_inputType);
                        print(_outputShape);
                        print(_outputType);
                      },
                      child: const Text('Show Info'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // _predictAll();
                        _convertImage();
                      },
                      child: const Text('Load image'),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    PickImageButton(onChoose: (XFile file) {
                      _pickImage(file);
                    }),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const HistoryPage();
                          },
                        ));
                      },
                      child: const Text('History'),
                    ),
                  ],
                ),
        ));
  }
}
