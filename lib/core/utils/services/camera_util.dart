import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class CameraService {
  List<CameraDescription>? _availableCameras;
  late CameraDescription _description;
  CameraController? _controller;
  late FaceDetector _detector;
  CameraLensDirection _camDirec = CameraLensDirection.front;

  bool isBusy = false;
  CameraImage? frame;
  img.Image? image;
  late Size size;

  CameraService() {
    _initializeCamera();
    _detector = FaceDetector(
      options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
    );
  }

  Future<void> _initializeCamera() async {
    _availableCameras = await availableCameras();
    _description = _availableCameras![1];
    _controller = CameraController(_description, ResolutionPreset.high);
    await _controller!.initialize().then((_) {
      size = _controller!.value.previewSize!;

      _controller!.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          frame = image;
        }
      });
    });
  }

  Future<List<Face>> detectFaces(CameraImage frame) async {
    final inputImage = _getInputImage(frame);
    return await _detector.processImage(inputImage);
  }

  InputImage _getInputImage(CameraImage frame) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame.width.toDouble(), frame.height.toDouble());
    final imageRotation =
        InputImageRotationValue.fromRawValue(_description.sensorOrientation);
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame.format.raw);
    final bytesPerRow = frame.planes.first.bytesPerRow;
    final inputImageMetaData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetaData);
  }

  void reverseCamera() async {
    if (_camDirec == CameraLensDirection.back) {
      _camDirec = CameraLensDirection.front;
      _description = _availableCameras![1];
    } else {
      _camDirec = CameraLensDirection.back;
      _description = _availableCameras![0];
    }
    await _controller!.stopImageStream();
    await _initializeCamera();
  }

  CameraController? get controller => _controller;
  CameraLensDirection get camDirection => _camDirec;
}
