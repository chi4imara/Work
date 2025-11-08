import SwiftUI

struct AnimationUtils {
    static func safeAnimation(
        duration: Double = 0.6,
        delay: Double = 0.0,
        curve: Animation = .easeOut
    ) -> Animation {
        let safeDelay = max(0, delay)
        return curve.delay(safeDelay)
    }
    
    static func safeListAnimation(
        duration: Double = 0.6,
        baseDelay: Double = 0.0,
        index: Int,
        stepDelay: Double = 0.1,
        curve: Animation = .easeOut
    ) -> Animation {
        let delay = baseDelay + Double(index) * stepDelay
        return safeAnimation(duration: duration, delay: delay, curve: curve)
    }
    
    static func safeOffsetAnimation(
        duration: Double = 0.6,
        delay: Double = 0.0,
        curve: Animation = .easeOut
    ) -> Animation {
        return safeAnimation(duration: duration, delay: delay, curve: curve)
    }
    
    static func safeDragAnimation(
        duration: Double = 0.3,
        curve: Animation = .easeInOut
    ) -> Animation {
        return curve
    }
}
