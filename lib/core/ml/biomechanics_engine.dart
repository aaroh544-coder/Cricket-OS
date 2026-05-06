import 'dart:math';

/// Phase 3: Biomechanical Telemetry Engine
/// Analyzes skeletal landmarks (pose estimation) to extract bowling biomechanics.
class BiomechanicsEngine {
  /// Calculates the bowling arm angle relative to the vertical axis.
  /// Used for detecting illegal bowling actions (throwing) or analyzing release consistency.
  /// 
  /// [shoulder] - 2D/3D point of the bowling shoulder
  /// [elbow] - 2D/3D point of the bowling elbow
  /// [wrist] - 2D/3D point of the bowling wrist
  static double calculateArmExtensionAngle(Point shoulder, Point elbow, Point wrist) {
    // Law of Cosines to find angle at the elbow
    double a = _distance(elbow, wrist);
    double b = _distance(shoulder, elbow);
    double c = _distance(shoulder, wrist);

    // angle = acos((a^2 + b^2 - c^2) / 2ab)
    double cosTheta = (pow(a, 2) + pow(b, 2) - pow(c, 2)) / (2 * a * b);
    
    // Clamp value for acos
    cosTheta = cosTheta.clamp(-1.0, 1.0);
    
    // Return angle in degrees (180 = perfectly straight arm)
    return acos(cosTheta) * (180 / pi);
  }

  /// Estimates the release height based on the wrist position relative to the ground.
  static double estimateReleaseHeight(double wristY, double groundY, double calibrationFactor) {
    // groundY is usually the popping crease level
    // calibrationFactor maps pixels to meters
    return (groundY - wristY) * calibrationFactor;
  }

  static double _distance(Point p1, Point p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
  }
}
