import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class GestureService {
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      model: PoseDetectionModel.base,
      mode: PoseDetectionMode.stream,
    ),
  );

  String detectGesture(Pose pose) {
    // Get key points
    final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
    final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

    if (leftWrist == null || rightWrist == null || 
        leftShoulder == null || rightShoulder == null) {
      return 'No gesture detected';
    }

    // Calculate relative positions
    final leftWristAboveShoulder = leftWrist.y < leftShoulder.y;
    final rightWristAboveShoulder = rightWrist.y < rightShoulder.y;
    final handsClose = (leftWrist.x - rightWrist.x).abs() < 0.2;

    // Detect basic gestures
    if (leftWristAboveShoulder && rightWristAboveShoulder && handsClose) {
      return '👋 Wave';
    } else if (leftWristAboveShoulder && rightWristAboveShoulder && !handsClose) {
      return '✌️ Peace';
    } else if (leftWristAboveShoulder || rightWristAboveShoulder) {
      return '👉 Pointing';
    }

    return 'No gesture detected';
  }

  Future<String> processImage(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final plane = image.planes.first;
      final inputImage = InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.bgra8888,
          bytesPerRow: plane.bytesPerRow,
        ),
      );

      final poses = await _poseDetector.processImage(inputImage);
      if (poses.isEmpty) {
        return 'No gesture detected';
      }

      return detectGesture(poses.first);
    } catch (e) {
      return 'Error detecting gesture';
    }
  }

  void dispose() {
    _poseDetector.close();
  }
} 