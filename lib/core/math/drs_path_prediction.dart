import 'dart:math';

class Vector3D {
  double x, y, z;
  Vector3D(this.x, this.y, this.z);
}

/// Core Mathematical Engine for DRS Lite Path Prediction
class DrsPathPrediction {
  // Gravity constant in m/s^2
  static const double gravity = -9.81;
  
  // Stumps bounding box (width of 3 stumps = ~0.228m, height = 0.711m)
  // Coordinates relative to the middle stump base (0, 0, 0)
  static const double stumpWidth = 0.228;
  static const double stumpHeight = 0.711;

  /// Predicts the trajectory of the ball after impact and returns whether it hits the stumps.
  /// 
  /// [impactPosition] - 3D coordinates (x, y, z) of the ball at the moment of impact with the pad.
  /// [initialVelocity] - The velocity vector (vx, vy, vz) at the moment of impact.
  /// [timeToStumps] - Estimated time from impact to the stump plane (z = 0 if stumps are at z=0).
  static bool predictWicketsHitting(Vector3D impactPosition, Vector3D initialVelocity) {
    // We assume the digital stumps are at z = 0 for the coordinate system.
    // The bowler releases from a positive z distance (e.g., z = 20.12m for 22 yards)
    // The impact happens at some z > 0.
    
    if (impactPosition.z <= 0) return false; // Already past the stumps

    // Time to reach the z=0 plane: z_0 + v_z * t = 0 => t = -z_0 / v_z
    // Note: v_z is negative as the ball is traveling towards z=0
    double t = -impactPosition.z / initialVelocity.z;

    if (t < 0) return false; // Ball is moving away from the stumps

    // Extrapolate x position (lateral movement, assuming constant horizontal velocity)
    // In a full implementation, we'd add Magnus effect (spin) and air resistance here
    double predictedX = impactPosition.x + (initialVelocity.x * t);

    // Extrapolate y position (vertical height), accounting for gravity
    // y(t) = y_0 + v_y * t + 0.5 * g * t^2
    double predictedY = impactPosition.y + (initialVelocity.y * t) + (0.5 * gravity * pow(t, 2));

    // Check intersection with stump bounding box
    return _checkStumpIntersection(predictedX, predictedY);
  }

  static bool _checkStumpIntersection(double x, double y) {
    bool withinWidth = (x >= -stumpWidth / 2) && (x <= stumpWidth / 2);
    bool withinHeight = (y >= 0) && (y <= stumpHeight);
    
    return withinWidth && withinHeight;
  }
}
