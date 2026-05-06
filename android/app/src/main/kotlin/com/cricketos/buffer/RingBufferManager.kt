package com.cricketos.buffer

import android.media.Image
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/**
 * RingBufferManager maintains a rolling buffer of frames (e.g., 3 seconds at 60fps = 180 frames).
 * This optimizes hardware resources and prevents overheating by not writing to disk continuously.
 */
class RingBufferManager(private val bufferSize: Int = 180) {
    private val frameBuffer = arrayOfNulls<Image>(bufferSize)
    private var headIndex = 0
    private var isLocked = false
    private val lock = ReentrantLock()

    // Holds the final combined list of frames when a trigger occurs
    private val capturedClip = mutableListOf<Image>()
    private var postTriggerCount = 0
    private val postTriggerTarget = 120 // 2 seconds at 60fps

    fun addFrame(frame: Image) {
        lock.withLock {
            if (isLocked) {
                // If the pre-buffer is locked, we are in post-trigger collection phase
                if (postTriggerCount < postTriggerTarget) {
                    capturedClip.add(frame)
                    postTriggerCount++
                } else {
                    // Clip collection complete, send for analysis
                    processClipAndReset()
                }
                return
            }

            // Normal operation: overwrite oldest frame
            frameBuffer[headIndex]?.close() // Free native resources
            frameBuffer[headIndex] = frame
            headIndex = (headIndex + 1) % bufferSize
        }
    }

    /**
     * Called when Acoustic/Visual trigger detects an event (e.g., bat hit).
     * Locks the buffer to preserve the last 3 seconds of footage.
     */
    fun triggerEvent() {
        lock.withLock {
            if (isLocked) return // Already triggered

            isLocked = true
            postTriggerCount = 0
            capturedClip.clear()

            // Extract the last 3 seconds (linearize the ring buffer)
            for (i in 0 until bufferSize) {
                val index = (headIndex + i) % bufferSize
                frameBuffer[index]?.let { capturedClip.add(it) }
            }
        }
    }

    private fun processClipAndReset() {
        // Here we would encode the capturedClip to an MP4 or pass directly to TFLite/OpenCV
        println("Captured ${capturedClip.size} frames (3s pre-buffer + 2s post-trigger). Processing...")
        
        // Reset state for the next delivery
        capturedClip.clear()
        isLocked = false
    }
}
