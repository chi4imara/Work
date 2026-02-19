import Foundation
import UserNotifications
import SwiftUI
import Combine

final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.authorizationStatus = granted ? .authorized : .denied
                if let error = error {
                    print("Notification authorization error: \(error.localizedDescription)")
                }
                completion(granted)
            }
        }
    }
    
    func requestPermissionIfNeeded(onResult: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    onResult(true)
                case .denied:
                    onResult(false)
                case .notDetermined, .ephemeral:
                    self?.requestAuthorization(completion: onResult)
                @unknown default:
                    self?.requestAuthorization(completion: onResult)
                }
            }
        }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    func isAuthorized(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let allowed = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
                completion(allowed)
            }
        }
    }
}
