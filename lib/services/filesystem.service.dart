import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import 'package:cats_vs_dogs/components/generic/generic_confirmation.dart';
import 'package:cats_vs_dogs/components/generic/generic_prompt.dart';

// import 'package:translate_1/ui/generic/widgets/generic_prompt.dart';
// import 'package:translate_1/ui/generic/widgets/generic_confirmation.dart';

part 'filesystem.service.g.dart';

class FileSystemService {
  Future<String?> pickFilePath() async {
    FilePickerResult? picked;
    try {
      picked = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );
    } catch (_) {
      print('Picking file failed');
    }
    if (picked == null || picked.count < 1) {
      return null;
    }
    return picked.paths.first;
  }

  Future<String?> pickDirectoryPath() async {
    String? picked;
    try {
      picked = await FilePicker.platform.getDirectoryPath();
    } catch (_) {
      print('Picking directory failed');
    }
    return picked;
  }

  Future<String> readTextFile(String path) async {
    File file = File(path);
    String contents = await file.readAsString();
    return contents;
  }

  Future<Map<String, dynamic>?> readJsonFile(String path) async {
    final contents = await readTextFile(path);
    if (contents.isEmpty) {
      return null;
    }
    final json = jsonDecode(contents);
    if (json is List) {
      return {'data': json};
    }
    return json;
  }

  Future<void> writeTextFile(String path, String body) async {
    File file = File(path);
    await file.writeAsString(body);
  }

  Future<void> writeJsonFile(String path, Map<String, dynamic> contents) async {
    final body = jsonEncode(contents);
    await writeTextFile(path, body);
  }

  Future<String?> requestFileName(BuildContext context) async {
    String? result;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (context) {
        final DateTime nowDate = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM');
        final String datePart = formatter.format(nowDate);
        return Padding(
          padding: EdgeInsets.fromLTRB(
              0, 0, 0, MediaQuery.of(context).viewInsets.bottom),
          child: GenericPrompt(
            title: 'Specify file name',
            initialValue: 'predictions-$datePart',
            onConfirm: (String? value) {
              result = value;
              if (result != null && result!.endsWith('.json')) {
                result = result!.substring(0, result!.length - 5);
              }
              Navigator.of(context).pop();
            },
            onReject: () {
              result = null;
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
    return result;
  }

  Future<bool> confirmFileOverwrite(
      bool fileExists, BuildContext context) async {
    if (!fileExists) {
      return true;
    }

    bool result = false;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (context) {
        return GenericConfirmation(
          title: 'File already exists',
          message: 'Overwrite the file?',
          onConfirm: () {
            result = true;
            Navigator.of(context).pop();
          },
          onReject: () {
            result = false;
            Navigator.of(context).pop();
          },
        );
      },
    );
    return result;
  }

  Future<bool> confirmContentReload(BuildContext context) async {
    bool result = false;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (context) {
        return GenericConfirmation(
          title: 'Data will be replaced',
          message: 'Replace current predictions? Unsaved data will be lost.',
          onConfirm: () {
            result = true;
            Navigator.of(context).pop();
          },
          onReject: () {
            result = false;
            Navigator.of(context).pop();
          },
        );
      },
    );
    return result;
  }
}

@Riverpod(keepAlive: true)
FileSystemService fileSystemService(FileSystemServiceRef ref) =>
    FileSystemService();
