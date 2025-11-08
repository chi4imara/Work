import Foundation

struct Constants {
    struct App {
        static let name = "MoodFans: AuraDay"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
    
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let moodEntries = "mood_entries"
        static let appLaunchCount = "app_launch_count"
        static let lastAppVersion = "last_app_version"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let termsOfService = "https://google.com"
        static let contactEmail = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
    }
    
    struct Limits {
        static let maxNoteLength = 500
        static let maxCalendarDays = 42 
        static let minSwipeDistance: CGFloat = 50
    }
    
    struct Notifications {
        static let moodEntryUpdated = "MoodEntryUpdated"
        static let favoriteToggled = "FavoriteToggled"
        static let monthCleared = "MonthCleared"
    }
}

extension MoodColor {
    static let defaultPalette: [MoodColor] = [
        .red, .orange, .yellow, .green,
        .blue, .purple, .gray, .white
    ]
    
    var hexValue: String {
        switch self {
        case .red: return "#FF3B30"
        case .orange: return "#FF9500"
        case .yellow: return "#FFCC00"
        case .green: return "#34C759"
        case .blue: return "#007AFF"
        case .purple: return "#AF52DE"
        case .gray: return "#8E8E93"
        case .white: return "#FFFFFF"
        }
    }
}

import UIKit

struct HapticFeedback {
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    static func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    static func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    static func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
}
