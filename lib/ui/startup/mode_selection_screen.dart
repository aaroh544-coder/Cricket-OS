import 'package:flutter/material.dart';

/// Phase 1: System Initialization (Mode Selection)
/// Upon startup, the system enters this state to optimize resource allocation
/// by loading only the necessary ML models and buffers for the chosen protocol.
class ModeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CRICKET OS",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  shadows: [Shadow(color: Colors.cyan, blurRadius: 10)],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "INITIALIZE PROTOCOL",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 64),

              _buildProtocolButton(
                title: "BATTING ANALYSIS",
                subtitle: "Biomechanics & Shot Classification",
                icon: Icons.sports_cricket,
                onTap: () => _loadProtocol("BATTING_ANALYSIS"),
              ),
              const SizedBox(height: 24),

              _buildProtocolButton(
                title: "BOWLING ANALYSIS",
                subtitle: "Release Telemetry & Velocity",
                icon: Icons.speed,
                onTap: () => _loadProtocol("BOWLING_ANALYSIS"),
              ),
              const SizedBox(height: 24),

              _buildProtocolButton(
                title: "FULL MATCH OFFICIATING",
                subtitle: "Match Rules, Digital Infrastructure & DRS",
                icon: Icons.stadium,
                isPrimary: true,
                onTap: () => _loadProtocol("FULL_MATCH_OFFICIATING"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.cyanAccent.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.cyan.withOpacity(0.1) : Colors.white10,
          border: Border.all(
            color: isPrimary ? Colors.cyanAccent : Colors.white24,
            width: isPrimary ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isPrimary ? Colors.cyanAccent : Colors.white70, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isPrimary ? Colors.cyanAccent : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadProtocol(String protocol) {
    print("[SYSTEM]: Loading Protocol -> \$protocol");
    // Depending on the protocol, we load specific TFLite models to RAM.
    // E.g., BATTING_ANALYSIS loads PoseNet + ShotClassifier LSTM.
    // FULL_MATCH_OFFICIATING loads PoseNet (Lower Body) + Audio Classifier + Object Tracker.
    
    // Routing logic goes here
    // Navigator.pushReplacementNamed(context, '/telemetry_hud');
  }
}
