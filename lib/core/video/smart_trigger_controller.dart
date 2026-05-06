import 'dart:async';
import 'smart_trigger_buffer.dart';
import 'thermal_manager.dart';

/// Phase 2: Smart Trigger Architecture - Controller
/// Orchestrates the rolling buffer, thermal management, and event triggers.
class SmartTriggerController {
  final SmartTriggerBuffer buffer = SmartTriggerBuffer();
  final AdaptiveThermalManager thermalManager = AdaptiveThermalManager();
  
  bool _isAutoTriggerEnabled = true;

  void initialize() {
    buffer.startCapture();
    thermalManager.startMonitoring();
    
    // Listen for thermal events to adjust capture quality/frequency
    thermalManager.frameRateStream.listen((fps) {
      // In a real implementation, we would update the CameraController's FPS here.
      print('[SmartTriggerController] Syncing camera FPS to $fps due to thermal pressure.');
    });
  }

  /// Commits the 3-second buffer to permanent storage.
  /// This is called when a 'Smart Event' is detected (e.g., Bowler Release or Voice Command).
  Future<void> commitEvent(String eventSource) async {
    print('[SmartTriggerController] COMMIT EVENT: $eventSource');
    
    final frames = buffer.triggerSave();
    if (frames.isNotEmpty) {
      print('[SmartTriggerController] Extracting ${frames.length} frames for $eventSource highlight.');
      // 1. Send frames to VideoEncoder to create a .mp4 clip
      // 2. Clear buffer to save RAM once committed
      // 3. Mark the match telemetry with the highlight path
    }
  }

  void toggleAutoTrigger(bool enabled) {
    _isAutoTriggerEnabled = enabled;
  }

  void dispose() {
    buffer.stopCapture();
    thermalManager.stopMonitoring();
  }
}
