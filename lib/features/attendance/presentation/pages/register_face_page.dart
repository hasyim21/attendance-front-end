import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import '../../../../core/core.dart';
import '../../../../main.dart';
import '../widgets/face_detector_painter.dart';
import '../widgets/show_face_registration_dialog.dart';

class RegisterFacePage extends StatefulWidget {
  const RegisterFacePage({super.key});

  @override
  State<RegisterFacePage> createState() => _RegisterFacePageState();
}

class _RegisterFacePageState extends State<RegisterFacePage> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  late Recognizer _recognizer;

  CameraDescription _description = cameras[1];
  CameraLensDirection _cameraDirection = CameraLensDirection.front;
  final List<RecognitionEmbedding> _recognitions = [];

  img.Image? _image;
  CameraImage? _frame;
  dynamic _scanResults;

  bool _isBusy = false;
  bool _isCameraInitialized = false;
  bool _isFaceRegistered = false;

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );
    _recognizer = Recognizer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(_description, ResolutionPreset.high);
    await _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }

      _controller.startImageStream((image) async {
        if (!_isBusy) {
          _isBusy = true;
          _frame = image;
          await Future.delayed(
            const Duration(milliseconds: 500),
          );
          await _doFaceDetectionOnFrame();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              width: size.width,
              height: size.height,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: CameraPreview(_controller),
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              width: size.width,
              height: size.height,
              child: _faceDetectionBox(),
            ),
            Positioned(
              bottom: 5.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const SpaceWidth(60.0),
                        const Spacer(),
                        IconButton(
                          onPressed: _takePicture,
                          icon: const Icon(
                            Icons.circle,
                            size: 70.0,
                          ),
                          color: MyColors.red,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 60.0,
                          child: IconButton(
                            onPressed: _reverseCamera,
                            icon: Assets.icons.reverse.svg(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      await _controller.takePicture();
      if (mounted) {
        setState(() {
          _isFaceRegistered = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error taking picture: $e');
      }
    }
  }

  Future<void> _reverseCamera() async {
    if (_cameraDirection == CameraLensDirection.back) {
      _cameraDirection = CameraLensDirection.front;
      _description = cameras[1];
    } else {
      _cameraDirection = CameraLensDirection.back;
      _description = cameras[0];
    }
    await _controller.stopImageStream();
    setState(() {
      _controller;
    });

    _initializeCamera();
  }

  Future<void> _doFaceDetectionOnFrame() async {
    InputImage inputImage = _getInputImage();
    List<Face> faces = await _faceDetector.processImage(inputImage);
    _performFaceRecognition(faces);
  }

  Future<void> _performFaceRecognition(List<Face> faces) async {
    _recognitions.clear();

    _image = ImageService.convertYUV420ToImage(_frame!);
    _image = img.copyRotate(_image!,
        angle: _cameraDirection == CameraLensDirection.front ? 270 : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;

      img.Image croppedFace = img.copyCrop(_image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      RecognitionEmbedding recognition =
          _recognizer.recognize(croppedFace, face.boundingBox);

      _recognitions.add(recognition);

      if (_isFaceRegistered) {
        showFaceRegistrationDialogue(
          context,
          croppedFace,
          recognition,
        );
        _isFaceRegistered = false;
      }
    }

    setState(() {
      _isBusy = false;
      _scanResults = _recognitions;
    });
  }

  InputImage _getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in _frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(_frame!.width.toDouble(), _frame!.height.toDouble());
    final camera = _description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(_frame!.format.raw);

    final int bytesPerRow = _frame?.planes.isNotEmpty == true
        ? _frame!.planes.first.bytesPerRow
        : 0;

    final inputImageMetaData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: bytesPerRow,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, metadata: inputImageMetaData);

    return inputImage;
  }

  Widget _faceDetectionBox() {
    if (_scanResults == null || !_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final Size imageSize = Size(
      _controller.value.previewSize!.height,
      _controller.value.previewSize!.width,
    );
    CustomPainter painter =
        FaceDetectorPainter(imageSize, _scanResults, _cameraDirection);
    return CustomPaint(
      painter: painter,
    );
  }
}
