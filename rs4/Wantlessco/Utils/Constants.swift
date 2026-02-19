import Foundation

struct AppConstants {
    static let appName = "Wantless"
    static let appVersion = "1.0.0"
    static let appDescription = "Track what you want — and what you don't"
    
    struct UserDefaultsKeys {
        static let isFirstLaunch = "IsFirstLaunch"
        static let wishEntries = "WishEntries"
        static let hasCompletedOnboarding = "HasCompletedOnboarding"
    }
    
    struct AnimationDurations {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 2.5
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 8
        static let padding: CGFloat = 16
        static let sidebarWidth: CGFloat = 280
    }
    
    struct Links {
        static let privacyPolicy = "https://google.com"
        static let contactEmail = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct OnboardingContent {
        static let title = "Track what you want — and what you don't."
        static let description = "This app helps you capture your real desires and refusals, even when they feel inconsistent or hard to explain. You add short entries, mark them as wants or no-wants, and see the full picture of your choices over time. It's a simple way to stay honest with yourself and navigate decisions more clearly."
    }
}
