import 'package:flutter/services.dart';

/// Phase 3: No-Ball Detection Service
/// Bridge to the native Kotlin EdgeAiUmpire for zero-latency haptic feedback.
class NoBallDetectionService {
  static const MethodChannel _channel = MethodChannel('com.cricketos.umpire/edge_ai');
  
  bool _isDetectionEnabled = false;

  /// Calibrates the popping crease Y-coordinate in the camera view.
  Future<void> calibrateCrease(double yCoordinate) async {
    try {
      await _channel.invokeMethod('calibrateCrease', {'yCoordinate': yCoordinate});
      print('[NoBallService] Crease calibrated at Y: $yCoordinate');
    } on PlatformException catch (e) {
      print('[NoBallService] Calibration failed: ${e.message}');
    }
  }

  /// Toggles the high-frequency detection engine.
  Future<void> setDetectionEnabled(bool enabled) async {
    _isDetectionEnabled = enabled;
    // In a real implementation, we might send this to native to pause processing.
  }

  /// Processes a frame on the Dart side (if not using pure native flow)
  /// and triggers the haptic feedback if a no-ball is detected.
  Future<void> reportHeelPosition(double heelY, bool isReleaseFrame) async {
    if (!_isDetectionEnabled) return;
    
    try {
      await _channel.invokeMethod('processFrame', {
        'frontHeelY': heelY,
        'isReleaseFrame': isReleaseFrame,
      });
    } on PlatformException catch (e) {
      print('[NoBallService] Frame processing failed: ${e.message}');
    }
  }
}
