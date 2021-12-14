import 'dart:developer';
import 'dart:io';

import 'package:cats_vs_dogs/src/application.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class SplashProvider extends ChangeNotifier {
  File? image;
  dynamic result;

  String get resultAsText {
    if (result == null) return '';
    // dog - 99%
    return '${result['label'].toString().substring(2)}'
        ' - '
        '${(result['confidence'] * 100).toInt()}%';
  }

  Future<void> pickAnImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;

    image = File(imageFile.path);
    _startTestingThisPhoto();
    notifyListeners();
  }

  Future<void> _startTestingThisPhoto() async {
    // loading mode land labels
    await Tflite.loadModel(
      model: "assets/tf/model.tflite",
      labels: "assets/tf/labels.txt",
    );

    // run image on model
    final recognitions = await Tflite.runModelOnImage(
      path: image!.path, // required
      imageMean: 0.0, // defaults to 117.0
      imageStd: 255.0, // defaults to 1.0
      numResults: 2, // defaults to 5
      threshold: 0.2, // defaults to 0.1
    );

    if (recognitions == null || recognitions.isEmpty) return;

    result = recognitions.first;
    notifyListeners();
    // closing model
    await Tflite.close();
  }
}
