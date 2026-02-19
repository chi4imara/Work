import Foundation

struct AppConstants {
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let savedProcedures = "SavedProcedures"
        static let savedSchedule = "SavedSchedule"
        static let dailyProgress = "DailyProgress"
        static let appVersion = "AppVersion"
    }
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let shadowRadius: CGFloat = 4
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 12
        static let buttonHeight: CGFloat = 44
    }
    
    struct FontSize {
        static let title: CGFloat = 28
        static let subtitle: CGFloat = 18
        static let body: CGFloat = 16
        static let caption: CGFloat = 14
        static let small: CGFloat = 12
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let contactEmail = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct AppInfo {
        static let name = "Care Routine"
        static let version = "1.0"
        static let minimumIOSVersion = "16.0"
    }
}
