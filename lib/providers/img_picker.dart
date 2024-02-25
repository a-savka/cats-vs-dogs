import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'img_picker.g.dart';

@Riverpod(keepAlive: true)
ImagePicker imgPicker(ImgPickerRef ref) => ImagePicker();
