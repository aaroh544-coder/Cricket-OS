package com.cricketos.umpire

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager

/**
 * EdgeAiUmpire runs high-frequency checks on pose estimation data to detect No-Balls.
 * It is implemented in Kotlin to ensure zero-latency haptic feedback upon detection.
 */
class EdgeAiUmpire(private val context: Context) {

    private val vibrator: Vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
        vibratorManager.defaultVibrator
    } else {
        @Suppress("DEPRECATION")
        context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
    }

    // Y-coordinate of the calibrated popping crease on the screen
    private var poppingCreaseY: Float = 0f

    fun calibrateCrease(yCoordinate: Float) {
        poppingCreaseY = yCoordinate
    }

    /**
     * Called per frame by the Pose Estimation model (e.g., MediaPipe)
     * 
     * @param frontHeelY The Y-coordinate of the bowler's front heel.
     * @param isReleaseFrame True if this frame corresponds to the ball release.
     */
    fun processFrame(frontHeelY: Float, isReleaseFrame: Boolean) {
        // In most screen coordinate systems, y increases downwards.
        // Assuming the bowler is running towards the camera at the bottom of the screen.
        // If heel Y is greater than crease Y, they have overstepped.
        if (isReleaseFrame) {
            if (frontHeelY > poppingCreaseY) {
                triggerNoBallAlert()
            }
        }
    }

    private fun triggerNoBallAlert() {
        // Instant high-intensity haptic feedback
        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createOneShot(200, VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(200)
            }
        }
        
        // Signal Flutter side to announce "No Ball" via Voice Caddy
        // (Implementation requires EventChannel invocation here)
    }
}
