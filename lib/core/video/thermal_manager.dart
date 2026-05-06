import 'dart:async';

/// Phase 2: Adaptive Thermal Management
/// Monitors device temperature and adjusts frame rates to prevent overheating.
class AdaptiveThermalManager {
  double _currentTemperature = 35.0; // Mock temperature in Celsius
  int _targetFrameRate = 60;
  Timer? _monitorTimer;

  final StreamController<int> _frameRateController = StreamController<int>.broadcast();
  Stream<int> get frameRateStream => _frameRateController.stream;

  void startMonitoring() {
    // In a real app, use a plugin like 'thermal' or 'battery_plus' to get actual stats.
    _monitorTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _simulateTemperatureFluctuation();
      _adjustFrameRate();
    });
  }

  void stopMonitoring() {
    _monitorTimer?.cancel();
  }

  void _simulateTemperatureFluctuation() {
    // Randomly fluctuate temperature for demonstration
    // If the camera is running, temperature usually climbs.
    _currentTemperature += (1.0 - 0.5); // Slight climb
    print('[ThermalManager] Current Temperature: ${_currentTemperature.toStringAsFixed(1)}°C');
  }

  void _adjustFrameRate() {
    int newRate = 60;

    if (_currentTemperature > 45.0) {
      newRate = 15; // Critical: Heavy throttling
    } else if (_currentTemperature > 40.0) {
      newRate = 30; // Warning: Minor throttling
    } else {
      newRate = 60; // Normal: Full performance
    }

    if (newRate != _targetFrameRate) {
      _targetFrameRate = newRate;
      _frameRateController.add(_targetFrameRate);
      print('[ThermalManager] Thermal event! Adjusting target FPS to $_targetFrameRate');
    }
  }

  double get currentTemperature => _currentTemperature;
  int get targetFrameRate => _targetFrameRate;
}
