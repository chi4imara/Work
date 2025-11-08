import Foundation

struct Constants {
    static let appName = "Claryon Tasks"
    static let appTagline = "Keep your space clean, one zone at a time"
    
    struct UserDefaultsKeys {
        static let savedZones = "SavedZones"
        static let savedCategories = "SavedCategories"
        static let hasSeenOnboarding = "HasSeenOnboarding"
        static let appLaunchCount = "AppLaunchCount"
        static let lastReviewRequestDate = "LastReviewRequestDate"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let termsOfService = "https://google.com"
        static let contactEmail = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct AnimationDurations {
        static let splash: Double = 2.5
        static let transition: Double = 0.5
        static let buttonPress: Double = 0.1
        static let cardAnimation: Double = 0.3
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let maxDescriptionLength = 500
    }
}
