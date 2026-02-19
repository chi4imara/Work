import Foundation
import UserNotifications
import SwiftUI

extension NeuralNexus: UNUserNotificationCenterDelegate {
    public func userNotificationDelegate(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler onComplete: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        onComplete([[.banner, .sound]])
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler onComplete: @escaping () -> Void
    ) {
        onComplete()
    }
}

class VelocityCalculator {
    private var lastPosition: CGPoint?
    private var lastTime: TimeInterval?
    private var velocities: [CGFloat] = []
    
    func calculate(from path: [CGPoint]) -> CGFloat {
        guard path.count >= 2 else { return 0 }
        
        let now = Date().timeIntervalSince1970
        let currentPosition = path.last!
        
        if let lastPos = lastPosition, let lastT = lastTime {
            let distance = hypot(currentPosition.x - lastPos.x, currentPosition.y - lastPos.y)
            let timeDiff = CGFloat(now - lastT)
            let velocity = distance / timeDiff
            
            velocities.append(velocity)
            if velocities.count > 10 {
                velocities.removeFirst()
            }
            
            let averageVelocity = velocities.reduce(0, +) / CGFloat(velocities.count)
            
            lastPosition = currentPosition
            lastTime = now
            
            return averageVelocity
        }
        
        lastPosition = currentPosition
        lastTime = now
        
        return 0
    }
}

struct Code {
    static let value: String = "12we32"
}

extension UIView {
    func hyperView<T: UIView>(of type: T.Type) -> T? {
        if let view = self as? T {
            return view
        }
        return superview?.hyperView(of: type)
    }
}
