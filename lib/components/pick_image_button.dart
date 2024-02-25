import 'package:cats_vs_dogs/providers/img_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class PickImageButton extends HookConsumerWidget {
  final void Function(XFile) onChoose;

  const PickImageButton({
    Key? key,
    required this.onChoose,
  }) : super(key: key);

  Future<void> _handleImagePick(ImageSource source, WidgetRef ref) async {
    ImagePicker picker = ref.read(imgPickerProvider);
    final imageFile = await picker.pickImage(source: source);
    if (imageFile != null) {
      onChoose(imageFile);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    NavigatorState navigator = Navigator.of(context);
                    navigator.pop();
                    await _handleImagePick(ImageSource.camera, ref);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_in_picture),
                  title: const Text('Gallery'),
                  onTap: () async {
                    NavigatorState navigator = Navigator.of(context);
                    navigator.pop();
                    await _handleImagePick(ImageSource.gallery, ref);
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text('Pick image'),
    );
  }
}
