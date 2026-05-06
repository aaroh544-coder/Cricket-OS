import 'dart:collection';
import 'dart:typed_data';

/// Represents a single frame captured from the camera
class VideoFrame {
  final Uint8List data;
  final DateTime timestamp;
  final int width;
  final int height;

  VideoFrame({
    required this.data,
    required this.timestamp,
    required this.width,
    required this.height,
  });
}

/// Phase 2: Smart Trigger Architecture
/// Implements an Intelligent Capture System to prevent hardware overheating and storage bloat.
/// Maintains a rolling buffer of frames (e.g., 3 seconds) in RAM.
class SmartTriggerBuffer {
  final Queue<VideoFrame> _frameBuffer = Queue<VideoFrame>();
  final Duration _bufferDuration;
  bool _isCapturing = false;

  SmartTriggerBuffer({Duration bufferDuration = const Duration(seconds: 3)})
      : _bufferDuration = bufferDuration;

  /// Starts the intelligent capture process
  void startCapture() {
    _isCapturing = true;
    _frameBuffer.clear();
    print('[SmartTrigger] Capture started. Rolling buffer initialized.');
  }

  /// Stops the capture process
  void stopCapture() {
    _isCapturing = false;
    _frameBuffer.clear();
    print('[SmartTrigger] Capture stopped. Buffer cleared.');
  }

  /// Adds a new frame to the rolling buffer.
  /// Automatically discards frames older than the specified buffer duration.
  void addFrame(VideoFrame frame) {
    if (!_isCapturing) return;

    _frameBuffer.add(frame);

    // Remove frames that are older than the buffer duration
    final cutoffTime = frame.timestamp.subtract(_bufferDuration);
    while (_frameBuffer.isNotEmpty &&
        _frameBuffer.first.timestamp.isBefore(cutoffTime)) {
      _frameBuffer.removeFirst();
    }
  }

  /// Triggers the save event, extracting the buffered frames for processing or saving to disk.
  List<VideoFrame> triggerSave() {
    if (!_isCapturing || _frameBuffer.isEmpty) {
      print('[SmartTrigger] No frames to save.');
      return [];
    }

    print('[SmartTrigger] Trigger activated! Saving ${_frameBuffer.length} frames.');
    // Return a copy of the current buffer
    final savedFrames = _frameBuffer.toList();
    
    // Keep the buffer running for subsequent events, or we can clear it depending on the exact requirement.
    // Usually, a trigger might save the pre-trigger buffer and continue capturing post-trigger.
    // For simplicity, we just return the captured frames.
    
    return savedFrames;
  }

  /// Returns the current number of frames in the buffer
  int get currentFrameCount => _frameBuffer.length;

  /// Returns whether the system is currently capturing
  bool get isCapturing => _isCapturing;
}
