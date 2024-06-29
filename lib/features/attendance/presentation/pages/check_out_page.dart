import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import '../../../../core/core.dart';
import '../../../../main.dart';
import '../bloc/check_out/check_out_bloc.dart';
import '../widgets/face_detector_painter.dart';
import 'attendance_success_page.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late CameraController _controller;
  late FaceDetector _faceDetector;
  late Recognizer _recognizer;

  CameraDescription _description = cameras[1];
  CameraLensDirection _camDirec = CameraLensDirection.front;
  final List<RecognitionEmbedding> _recognitions = [];

  img.Image? _image;
  CameraImage? _frame;
  dynamic _scanResults;

  bool _isBusy = false;
  bool _isCameraInitialized = false;
  bool _isFaceRegistered = false;
  String _faceStatusMessage = '';
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );
    _recognizer = Recognizer();
    _initializeCamera();
    _getCurrentPosition();
  }

  _initializeCamera() async {
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
              top: 20.0,
              left: 40.0,
              right: 40.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: _isFaceRegistered
                      ? MyColors.primary.withOpacity(0.47)
                      : MyColors.red.withOpacity(0.47),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  _faceStatusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 5.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  children: [
                    const SpaceWidth(60.0),
                    const Spacer(),
                    BlocConsumer<CheckOutBloc, CheckOutState>(
                      listener: (context, state) {
                        if (state is CheckOutError) {
                          MySnackbar.show(
                            context,
                            message: state.failure.message,
                            backgroundColor: MyColors.red,
                          );
                        }

                        if (state is CheckOutSuccess) {
                          context.pushReplacement(
                            const AttendanceSuccessPage(
                              status: 'Check Out',
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is CheckOutLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return IconButton(
                          onPressed: _isFaceRegistered ? _takeAttendance : null,
                          icon: const Icon(
                            Icons.circle,
                            size: 70.0,
                          ),
                          color:
                              _isFaceRegistered ? MyColors.red : MyColors.grey,
                        );
                      },
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _takeAttendance() {
    context.read<CheckOutBloc>().add(
          CheckOutEvent(
            latitude: latitude.toString(),
            longitude: longitude.toString(),
          ),
        );
  }

  void _reverseCamera() async {
    if (_camDirec == CameraLensDirection.back) {
      _camDirec = CameraLensDirection.front;
      _description = cameras[1];
    } else {
      _camDirec = CameraLensDirection.back;
      _description = cameras[0];
    }
    await _controller.stopImageStream();
    setState(() {
      _controller;
    });

    _initializeCamera();
  }

  _doFaceDetectionOnFrame() async {
    InputImage inputImage = _getInputImage();
    List<Face> faces = await _faceDetector.processImage(inputImage);
    _performFaceRecognition(faces);
  }

  _performFaceRecognition(List<Face> faces) async {
    _recognitions.clear();

    _image = ImageService.convertYUV420ToImage(_frame!);
    _image = img.copyRotate(_image!,
        angle: _camDirec == CameraLensDirection.front ? 270 : 90);

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

      bool isValid = await _recognizer.isValidFace(recognition.embedding);

      if (isValid) {
        setState(() {
          _isFaceRegistered = true;
          _faceStatusMessage = 'Wajah sudah terdaftar';
        });
      } else {
        setState(() {
          _isFaceRegistered = false;
          _faceStatusMessage = 'Wajah belum terdaftar';
        });
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

  Future<void> _getCurrentPosition() async {
    try {
      final position = await LocationService.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;

      setState(() {});
    } catch (e) {
      if (mounted) {
        MySnackbar.show(
          context,
          message: 'Gagal mendapatkan posisi lokasi',
          backgroundColor: MyColors.red,
        );
      }
    }
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
        FaceDetectorPainter(imageSize, _scanResults, _camDirec);
    return CustomPaint(
      painter: painter,
    );
  }
}
