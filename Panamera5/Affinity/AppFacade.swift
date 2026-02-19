import SwiftUI
import UserNotifications

public class AppFacade: NSObject, UIApplicationDelegate {
    public func application(
        _ app: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        setupNotifications(app)
        LeaderboardStarChaser.shared.incrementLaunchCount()
        
        app.registerForRemoteNotifications()
        
        return true
    }
    
    private func setupNotifications(_ app: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authorizationOptions,
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

extension AppFacade: UNUserNotificationCenterDelegate {
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
