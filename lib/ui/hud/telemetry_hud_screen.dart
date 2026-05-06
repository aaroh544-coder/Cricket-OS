import 'package:flutter/material.dart';
import 'dart:math';

/// Phase 3 & 4: Full Match Officiating UI Layout (Telemetry HUD)
class TelemetryHudScreen extends StatelessWidget {
  final double currentRunRate = 6.4;
  final double requiredRunRate = 8.2;
  final String ballSpeed = "122";
  final String ballType = "In-swinger";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback if camera fails
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Base Layer: Camera Preview (Mocked as a dark grey container for now)
          Container(
            color: Colors.grey.shade900,
            child: const Center(
              child: Text(
                "[ LIVE CAMERA FEED ]",
                style: TextStyle(color: Colors.white24, letterSpacing: 4),
              ),
            ),
          ),

          // 2. AR Overlay Layer (Digital Stumps & Smart Wide-Lines)
          CustomPaint(
            painter: ArOverlayPainter(),
            size: Size.infinite,
          ),

          // 3. Telemetry HUD Layer
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top HUD: Run Rates & Trend
                _buildTopHud(),
                
                // Edge-AI Umpire Hidden Vibration Alert Trigger
                // (Logic handled in ViewModel, UI doesn't need to show it unless debugging)

                // Bottom HUD: SpeedRadar, AI Voice & Ball Classification
                _buildBottomHud(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHud() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CRR & RRR
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CRR $currentRunRate",
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Roboto', // Professional Tech Font
                  shadows: [Shadow(color: Colors.cyan, blurRadius: 10)],
                ),
              ),
              Text(
                "RRR $requiredRunRate",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),

          // Sparkline Trend
          Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              color: Colors.black45,
            ),
            child: CustomPaint(painter: SparklinePainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHud() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ball Type Label (LSTM Output)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amberAccent.withOpacity(0.2),
              border: Border.all(color: Colors.amberAccent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              ballType.toUpperCase(),
              style: const TextStyle(
                color: Colors.amberAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // SpeedRadar Pro
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    ballSpeed,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "KM/H",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Voice Command Indicator
              Column(
                children: [
                  const Icon(Icons.mic, color: Colors.cyanAccent, size: 32),
                  const SizedBox(height: 4),
                  Text(
                    "LISTENING",
                    style: TextStyle(
                      color: Colors.cyanAccent.withOpacity(0.8),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Painter for AR Stumps and Wide Lines (High-contrast vector overlays)
class ArOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4); // Neon glow

    // Mock coordinates for Wide Lines
    final double leftWide = size.width * 0.15;
    final double rightWide = size.width * 0.85;
    final double bottomCrease = size.height * 0.7;

    // Draw Smart Wide-Lines
    canvas.drawLine(Offset(leftWide, size.height), Offset(leftWide, size.height * 0.6), paint);
    canvas.drawLine(Offset(rightWide, size.height), Offset(rightWide, size.height * 0.6), paint);

    // Draw Popping Crease
    final creasePaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, bottomCrease), Offset(size.width, bottomCrease), creasePaint);

    // Draw Digital Stumps (Mocked as 3 vertical lines for now)
    final stumpPaint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5); // Glowing stumps

    final centerX = size.width / 2;
    final stumpBaseY = bottomCrease - 20;
    final stumpTopY = stumpBaseY - 120;

    canvas.drawLine(Offset(centerX, stumpBaseY), Offset(centerX, stumpTopY), stumpPaint); // Middle
    canvas.drawLine(Offset(centerX - 20, stumpBaseY), Offset(centerX - 20, stumpTopY), stumpPaint); // Leg
    canvas.drawLine(Offset(centerX + 20, stumpBaseY), Offset(centerX + 20, stumpTopY), stumpPaint); // Off
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Small visual trend graph for Current Run Rate
class SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Mock run rate trend data points
    final List<double> points = [0.8, 0.6, 0.7, 0.4, 0.2]; 
    
    final double stepX = size.width / (points.length - 1);
    
    for (int i = 0; i < points.length; i++) {
      double x = i * stepX;
      double y = size.height * points[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
