import Foundation

struct Constants {
    static let appName = "MiraTalk"
    static let appVersion = "1.0.0"
    static let minimumIOSVersion = "16.0"
    
    struct UserDefaultsKeys {
        static let showOnboarding = "showOnboarding"
        static let selectedCategories = "selectedCategories"
        static let favorites = "favorites"
        static let history = "history"
        static let firstLaunch = "firstLaunch"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let termsOfUse = "https://google.com"
        static let contactEmail = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct Limits {
        static let maxHistoryEntries = 100
        static let maxFavorites = 500
        static let questionTextMaxLength = 500
    }
    
    struct AnimationDurations {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 2.5
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 56
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
    }
}
