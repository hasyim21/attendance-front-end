import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import '../../../../core/core.dart';
import '../widgets/face_detector_painter.dart';
import '../widgets/show_face_registration_dialog.dart';

class RegisterFacePage extends StatefulWidget {
  const RegisterFacePage({super.key});

  @override
  State<RegisterFacePage> createState() => _RegisterFacePageState();
}

class _RegisterFacePageState extends State<RegisterFacePage> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  CameraLensDirection _cameraDirection = CameraLensDirection.front;
  late List<RecognitionEmbedding> recognitions = [];
  late FaceDetector _detector;
  late Recognizer _recognizer;
  img.Image? _image;
  dynamic _scanResults;
  CameraImage? frame;
  bool _register = false;
  bool _isBusy = false;

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameraDirection == CameraLensDirection.front
            ? _cameras[1]
            : _cameras[0],
        ResolutionPreset.high,
      );

      await _controller.initialize();
      if (!mounted) {
        return;
      }
      _controller.startImageStream((CameraImage image) {
        if (!_isBusy) {
          _isBusy = true;
          frame = image;
          _doFaceDetectionOnFrame();
        }
      });
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
    }
  }

  Future<void> _reverseCamera() async {
    setState(() {
      _cameraDirection = _cameraDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
    });
    await _initializeCamera();
  }

  Future<void> _takePicture() async {
    try {
      await _controller.takePicture();
      if (mounted) {
        setState(() {
          _register = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error taking picture: $e');
      }
    }
  }

  InputImage _getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame!.width.toDouble(), frame!.height.toDouble());
    final camera = _cameras[1];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);

    final int bytesPerRow =
        frame?.planes.isNotEmpty == true ? frame!.planes.first.bytesPerRow : 0;

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

  _doFaceDetectionOnFrame() async {
    InputImage inputImage = _getInputImage();
    List<Face> faces = await _detector.processImage(inputImage);
    _performFaceRecognition(faces);
  }

  _performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    // convert CameraImage to Image and rotate it so that our frame will be in a portrait
    _image = ImageService.convertYUV420ToImage(frame!);
    _image = img.copyRotate(_image!,
        angle: _cameraDirection == CameraLensDirection.front ? 270 : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      // crop face
      img.Image croppedFace = img.copyCrop(_image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      // pass cropped face to face recognition model
      RecognitionEmbedding recognition =
          _recognizer.recognize(croppedFace, face.boundingBox);

      recognitions.add(recognition);

      // show face registration dialogue
      if (_register) {
        showFaceRegistrationDialogue(
          context,
          croppedFace,
          recognition,
        );
        _register = false;
      }
    }

    setState(() {
      _isBusy = false;
      _scanResults = recognitions;
    });
  }

  Widget _buildResult() {
    if (_scanResults == null || !_controller.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
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

  @override
  void initState() {
    super.initState();
    _detector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );
    _recognizer = Recognizer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (!_controller.value.isInitialized) {
      return const CircularProgressIndicator();
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
              child: _buildResult(),
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
                        IconButton(
                          onPressed: _reverseCamera,
                          icon: Assets.icons.reverse.svg(width: 48.0),
                        ),
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
                        const SpaceWidth(48.0)
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
}
