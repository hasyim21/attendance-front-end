import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

import '../../../../core/core.dart';
import '../bloc/check_out/check_out_bloc.dart';
import '../widgets/face_detector_painter.dart';
import 'attendance_success_page.dart';
import 'location_page.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List<CameraDescription>? _availableCameras;
  late CameraDescription description = _availableCameras![1];
  CameraController? _controller;
  bool isBusy = false;
  late List<RecognitionEmbedding> recognitions = [];
  late Size size;
  CameraLensDirection camDirec = CameraLensDirection.front;
  bool isFaceRegistered = false;
  String faceStatusMessage = '';
  late FaceDetector detector;
  late Recognizer recognizer;
  double? latitude;
  double? longitude;
  dynamic _scanResults;
  CameraImage? frame;
  img.Image? image;
  bool register = false;

  @override
  void initState() {
    super.initState();
    detector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );
    recognizer = Recognizer();
    _initializeCamera();
    _getCurrentPosition();
  }

  _initializeCamera() async {
    _availableCameras = await availableCameras();
    _controller = CameraController(description, ResolutionPreset.high);
    await _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      size = _controller!.value.previewSize!;

      _controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          frame = image;
          doFaceDetectionOnFrame();
        }
      });
    });
  }

  doFaceDetectionOnFrame() async {
    InputImage inputImage = getInputImage();

    List<Face> faces = await detector.processImage(inputImage);

    for (Face face in faces) {
      print("Face location ${face.boundingBox}");
    }

    performFaceRecognition(faces);
  }

  performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    image = ImageService.convertYUV420ToImage(frame!);
    image = img.copyRotate(image!,
        angle: camDirec == CameraLensDirection.front ? 270 : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;

      img.Image croppedFace = img.copyCrop(image!,
          x: faceRect.left.toInt(),
          y: faceRect.top.toInt(),
          width: faceRect.width.toInt(),
          height: faceRect.height.toInt());

      RecognitionEmbedding recognition =
          recognizer.recognize(croppedFace, face.boundingBox);

      recognitions.add(recognition);

      bool isValid = await recognizer.isValidFace(recognition.embedding);

      if (isValid) {
        setState(() {
          isFaceRegistered = true;
          faceStatusMessage = 'Wajah sudah terdaftar';
        });
      } else {
        setState(() {
          isFaceRegistered = false;
          faceStatusMessage = 'Wajah belum terdaftar';
        });
      }
    }

    setState(() {
      isBusy = false;
      _scanResults = recognitions;
    });
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame!.width.toDouble(), frame!.height.toDouble());
    final camera = description;
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

  void _reverseCamera() async {
    if (camDirec == CameraLensDirection.back) {
      camDirec = CameraLensDirection.front;
      description = _availableCameras![1];
    } else {
      camDirec = CameraLensDirection.back;
      description = _availableCameras![0];
    }
    await _controller!.stopImageStream();
    setState(() {
      _controller;
    });

    _initializeCamera();
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

  void _takeAttendance() {
    context.read<CheckOutBloc>().add(
          CheckOutEvent(
            latitude: latitude.toString(),
            longitude: longitude.toString(),
          ),
        );
  }

  Widget _buildResult() {
    if (_scanResults == null || !_controller!.value.isInitialized) {
      return const Center(
        child: Text('Camera is not initialized'),
      );
    }
    final Size imageSize = Size(
      _controller!.value.previewSize!.height,
      _controller!.value.previewSize!.width,
    );
    CustomPainter painter =
        FaceDetectorPainter(imageSize, _scanResults, camDirec);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
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
              top: 20.0,
              left: 40.0,
              right: 40.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isFaceRegistered
                      ? MyColors.primary.withOpacity(0.47)
                      : MyColors.red.withOpacity(0.47),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  faceStatusMessage,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: MyColors.primary.withOpacity(0.47),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Absensi Datang',
                                style: TextStyle(
                                  color: MyColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Kantor',
                                style: TextStyle(
                                  color: MyColors.white,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push(LocationPage(
                                latitude: latitude,
                                longitude: longitude,
                              ));
                            },
                            child:
                                Assets.images.seeLocation.image(height: 30.0),
                          ),
                        ],
                      ),
                    ),
                    const SpaceHeight(15.0),
                    const SpaceHeight(15.0),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _reverseCamera,
                          icon: Assets.icons.reverse.svg(width: 48.0),
                        ),
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
                                  status: 'Berhasil CheckOut',
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
                              onPressed:
                                  isFaceRegistered ? _takeAttendance : null,
                              icon: const Icon(
                                Icons.circle,
                                size: 70.0,
                              ),
                              color: isFaceRegistered
                                  ? MyColors.red
                                  : MyColors.grey,
                            );
                          },
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
