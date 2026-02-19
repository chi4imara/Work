import Foundation
import UserNotifications
import SwiftUI

extension AppAssembly: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(
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

extension UIView {
    func superView<T: UIView>(of type: T.Type) -> T? {
        if let view = self as? T {
            return view
        }
        return superview?.superView(of: type)
    }
}
