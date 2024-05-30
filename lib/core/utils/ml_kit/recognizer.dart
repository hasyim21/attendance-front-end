// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../../main.dart';
import '../../core.dart';

class Recognizer {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;
  static const int WIDTH = 112;
  static const int HEIGHT = 112;
  final localdb = AuthLocalDatasourceImpl(prefs: prefs);
  String get modelName => 'assets/mobile_face_net.tflite';

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      if (kDebugMode) {
        print(
            'Unable to create interpreter, Caught Exception: ${e.toString()}');
      }
    }
  }

  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
  }

  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
        img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  RecognitionEmbedding recognize(img.Image image, Rect location) {
    var input = imageToArray(image);
    if (kDebugMode) {
      print(input.shape.toString());
    }

    List output = List.filled(1 * 192, 0).reshape([1, 192]);
    interpreter.run(input, output);
    List<double> outputArray = output.first.cast<double>();

    return RecognitionEmbedding(location, outputArray);
  }

  PairEmbedding findNearest(List<double> emb, List<double> authFaceEmbedding) {
    PairEmbedding pair = PairEmbedding(-5);

    double distance = 0;
    for (int i = 0; i < emb.length; i++) {
      double diff = emb[i] - authFaceEmbedding[i];
      distance += diff * diff;
    }
    distance = sqrt(distance);
    if (pair.distance == -5 || distance < pair.distance) {
      pair.distance = distance;
    }

    return pair;
  }

  Future<bool> isValidFace(List<double> emb) async {
    final userData = await localdb.getUser();
    final faceEmbedding = userData!.faceEmbedding;
    PairEmbedding pair = findNearest(
        emb,
        faceEmbedding
            .split(',')
            .map((e) => double.parse(e))
            .toList()
            .cast<double>());
    if (kDebugMode) {
      print("distance= ${pair.distance}");
    }
    if (pair.distance < 1.0) {
      return true;
    }
    return false;
  }
}

class PairEmbedding {
  double distance;
  PairEmbedding(this.distance);
}
