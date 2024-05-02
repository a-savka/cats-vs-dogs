import 'package:cats_vs_dogs/models/prediction.dart';
import 'package:cats_vs_dogs/components/confirm_delete.dart';
import 'package:cats_vs_dogs/providers/ordered_predictions_provider.dart';
import 'package:cats_vs_dogs/services/filesystem.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data/flutter_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';

class OptionsPage extends StatefulHookConsumerWidget {
  const OptionsPage({super.key});

  @override
  ConsumerState<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends ConsumerState<OptionsPage> {
  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(40),
  );

  Future<void> _saveToFile() async {
    final FileSystemService fileSystem = ref.read(fileSystemServiceProvider);
    final predictionsData = await ref.read(orderedPredictionsProvider.future);
    if (predictionsData == null) {
      return;
    }
    final Predictions predictions = Predictions(predictionsData);
    String? path = await fileSystem.pickDirectoryPath();
    if (path != null && mounted) {
      String? fileName = await fileSystem.requestFileName(context);
      if (fileName != null) {
        path = '$path/$fileName.json';
        final fileExists = await File(path).exists();
        if (mounted) {
          final operationConfirmed =
              await fileSystem.confirmFileOverwrite(fileExists, context);
          if (operationConfirmed) {
            await fileSystem.writeJsonFile(path, predictions.toJson());
          }
        }
      }
    }
  }

  Future<void> _readFromFile() async {
    final repo = ref.read(predictionsRepositoryProvider);
    final FileSystemService fileSystem = ref.read(fileSystemServiceProvider);
    bool confirmed = await fileSystem.confirmContentReload(context);
    if (!confirmed) {
      return;
    }
    repo.clear();
    final path = await fileSystem.pickFilePath();
    if (path != null) {
      final json = await fileSystem.readJsonFile(path);
      if (json != null) {
        List<Prediction> predictions = Predictions.fromJson(json).data;
        for (Prediction prediction in predictions) {
          prediction.saveLocal();
        }
      }
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return ConfirmDelete(
                            text: 'Clear all stored data?',
                            onConfirmed: (bool isConfirmed) {
                              if (isConfirmed) {
                                final repo =
                                    ref.read(predictionsRepositoryProvider);
                                repo.clear();
                              }
                            },
                          );
                        },
                      );
                    },
                    child: const Text('Clear'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _saveToFile();
                    },
                    child: const Text('Export to file'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _readFromFile();
                    },
                    child: const Text('Import from file'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
