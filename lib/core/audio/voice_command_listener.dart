import 'dart:async';

/// Hands-Free Voice Command Mode (Keyword Spotting)
/// Utilizes a lightweight TFLite Audio Classification model to detect trigger phrases
/// such as "Hey Cricket OS" without relying on cloud APIs.
class VoiceCommandListener {
  bool _isListening = false;
  // StreamController to broadcast detected commands to the UI/Logic layers
  final StreamController<String> _commandStreamController = StreamController<String>.broadcast();
  
  Stream<String> get commandStream => _commandStreamController.stream;

  /// Starts listening to the microphone buffer for keyword spotting.
  Future<void> startListening() async {
    if (_isListening) return;
    _isListening = true;
    print("[VoiceCommandListener] Starting continuous audio buffer analysis...");

    // In a production environment:
    // 1. Hook into Android/iOS native AudioRecord stream.
    // 2. Feed 1-second chunks of audio (16kHz PCM) into a TFLite model.
    // 3. The model outputs a probability array matching keywords.
    // final interpreter = await Interpreter.fromAsset('keyword_spotter.tflite');
    
    // Simulating background listening...
  }

  /// Stops listening and releases microphone resources.
  void stopListening() {
    _isListening = false;
    print("[VoiceCommandListener] Stopped listening.");
  }

  /// Called when the TFLite native bridge detects a high-probability match.
  void _onKeywordDetected(String keyword) {
    if (!_isListening) return;

    print("[VoiceCommandListener] Keyword Detected: $keyword");
    
    // Map raw keywords to actionable application commands
    switch (keyword) {
      case "hey_cricket_os_show_replay":
        _commandStreamController.add("ACTION_SHOW_REPLAY");
        break;
      case "hey_cricket_os_start_bowling":
        _commandStreamController.add("ACTION_START_BOWLING_ANALYSIS");
        break;
      case "hey_cricket_os_result_four":
        _commandStreamController.add("ACTION_SCORE_FOUR");
        break;
      case "hey_cricket_os_result_single":
        _commandStreamController.add("ACTION_SCORE_SINGLE");
        break;
      default:
        print("Unknown command detected.");
    }
  }

  void dispose() {
    _commandStreamController.close();
  }
}
