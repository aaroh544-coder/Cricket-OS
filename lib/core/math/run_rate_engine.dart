import 'dart:math';

/// Phase 5: Mathematical Engine & Dynamic Match Predictor
/// Handles the unique cricket math where overs count from .1 to .6
class RunRateEngine {
  
  /// Converts cricket overs representation (e.g. 4.2 overs) into total legal balls bowled.
  /// 4.2 overs = 4 * 6 + 2 = 26 balls.
  static int oversToTotalBalls(double overs) {
    int completedOvers = overs.truncate();
    // Round to 1 decimal place to avoid floating point errors
    double fractionalPart = double.parse((overs - completedOvers).toStringAsFixed(1));
    int ballsInCurrentOver = (fractionalPart * 10).round();
    
    // Safety check, though 0.7+ should be handled by validation before this
    if (ballsInCurrentOver > 6) ballsInCurrentOver = 6;

    return (completedOvers * 6) + ballsInCurrentOver;
  }

  /// Calculates the Current Run Rate (CRR).
  static double calculateCRR(int totalRuns, double oversBowled) {
    int totalBalls = oversToTotalBalls(oversBowled);
    if (totalBalls == 0) return 0.0;
    
    // CRR = (Total Runs / Total Balls) * 6
    return (totalRuns / totalBalls) * 6.0;
  }

  /// Calculates the Required Run Rate (RRR) during the 2nd Innings.
  static double calculateRRR(int targetRuns, int currentRuns, double maxOvers, double oversBowled) {
    int runsRequired = targetRuns - currentRuns;
    if (runsRequired <= 0) return 0.0;

    int totalMaxBalls = (maxOvers.truncate() * 6);
    int totalBallsBowled = oversToTotalBalls(oversBowled);
    int ballsRemaining = totalMaxBalls - totalBallsBowled;

    if (ballsRemaining <= 0) return 0.0;

    return (runsRequired / ballsRemaining) * 6.0;
  }

  /// Automated Ball-by-Ball Event Logic
  /// Processes the outcome of a ball and updates the score.
  static Map<String, dynamic> processDelivery(int currentRuns, double currentOvers, int runsScored, bool isExtra) {
    int newRuns = currentRuns + runsScored;
    double newOvers = currentOvers;
    
    if (!isExtra) {
      int totalBalls = oversToTotalBalls(currentOvers) + 1;
      int completed = totalBalls ~/ 6;
      int remainder = totalBalls % 6;
      newOvers = completed + (remainder / 10.0);
    } else {
      // Extras (Wides/No-Balls) add a run but do not count as a legal delivery
      newRuns += 1; 
    }

    return {
      "runs": newRuns,
      "overs": newOvers,
    };
  }

  /// Win Predictor Logic based on Run Rate Comparison
  /// Returns a win probability for the batting team (0.0 to 1.0).
  static double calculateWinProbability(double crr, double rrr) {
    if (rrr <= 0) return 1.0; // Target reached
    if (crr == 0 && rrr > 0) return 0.1; // Baseline if no runs scored yet

    // Simple Ratio Prediction: 
    // If CRR >= RRR, probability > 50%. 
    // We use a sigmoid-like curve adjustment or simple ratio capped at bounds.
    double ratio = crr / rrr;
    
    // Baseline 50% chance when CRR == RRR
    double probability = 0.5 * ratio;

    // Cap between 5% and 95% unless match is over
    return min(max(probability, 0.05), 0.95);
  }
}
