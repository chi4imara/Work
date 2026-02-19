import Foundation

struct Constants {
    struct UserDefaults {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let savedProducts = "SavedProducts"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let contactUs = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let splashDuration: Double = 2.5
        static let buttonPress: Double = 0.1
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 12
        static let iconSize: CGFloat = 24
        static let largeIconSize: CGFloat = 60
    }
    
    struct Fonts {
        static let title: CGFloat = 28
        static let headline: CGFloat = 20
        static let body: CGFloat = 16
        static let caption: CGFloat = 14
        static let small: CGFloat = 12
    }
}