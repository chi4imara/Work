import SwiftUI
import UserNotifications

public class AppAssembly: NSObject, UIApplicationDelegate {
    public func application(
        _ app: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        prepareNotifications(app)
        GalaxyRankTracker.shared.addLaunchToCount()
        
        app.registerForRemoteNotifications()
        
        return true
    }
    
    private func prepareNotifications(_ notification: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let notificationCapabilities: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: notificationCapabilities,
            completionHandler: { _, _ in }
        )
    }
    
    public func application(_ app: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken fcmToken: Data) {
        let tokenParts = fcmToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        UserDefaults.standard.set(token, forKey: "DeviceToken")
        
    }
    
    public func application(_ app: UIApplication,
                            didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}
