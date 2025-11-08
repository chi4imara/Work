import Foundation

struct Constants {
    struct UserDefaultsKeys {
        static let onboardingComplete = "OnboardingComplete"
        static let savedGiftIdeas = "SavedGiftIdeas"
        static let currentSortOption = "CurrentSortOption"
    }
    
    struct Animation {
        static let short: Double = 0.3
        static let medium: Double = 0.5
        static let long: Double = 1.0
        static let splash: Double = 3.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 25
        static let shadowRadius: CGFloat = 4
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
    }
    
    struct URLs {
        static let termsOfUse = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let contactUs = "https://google.com"
        static let support = "https://google.com"
    }
    
    struct AppInfo {
        static let name = "Thoughtful Presents"
        static let version = "1.0"
        static let minimumIOSVersion = "16.0"
    }
}
