import Foundation

struct AppConstants {
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "HasSeenOnboarding"
        static let scentEntries = "ScentEntries"
        static let scentCategories = "ScentCategories"
        static let selectedSortOption = "SelectedSortOption"
    }
    
    struct Limits {
        static let maxAssociationsLength = 500
        static let maxCategoryNameLength = 50
        static let maxScentNameLength = 100
        static let previewTextLines = 2
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let splashDuration: Double = 3.0
        static let tabSwitchDuration: Double = 0.2
        static let cardAnimationDuration: Double = 0.25
    }
    
    struct Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
    }
    
    static let defaultCategories = [
        "Nature",
        "Home", 
        "Cafe / Food",
        "City",
        "Aromas"
    ]
    
    struct URLs {
        static let termsOfUse = "https://www.termsfeed.com/live/169201ee-0821-4a39-9501-0f3c8a36d005"
        static let privacyPolicy = "https://www.termsfeed.com/live/e0685df3-ed54-4530-9571-40c32e642a13"
        static let contactEmail = "https://www.termsfeed.com/live/e0685df3-ed54-4530-9571-40c32e642a13"
        static let appStore = "https://google.com"
    }
}
