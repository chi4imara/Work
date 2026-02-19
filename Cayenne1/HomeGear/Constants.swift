import Foundation

struct AppConstants {
    
    struct UserDefaultsKeys {
        static let inventoryItems = "InventoryItems"
        static let notes = "Notes"
        static let hasLaunchedBefore = "HasLaunchedBefore"
        static let isFirstLaunch = "IsFirstLaunch"
    }
    
    struct AnimationDurations {
        static let splash: Double = 3.0
        static let pageTransition: Double = 0.3
        static let buttonPress: Double = 0.2
        static let cardAppear: Double = 0.4
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 15
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let iconSize: CGFloat = 24
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let contactEmail = "https://google.com"
        static let support = "https://google.com"
        static let about = "https://google.com"
    }
    
    struct AppInfo {
        static let name = "HomeGear"
        static let version = "1.0.0"
        static let description = "Keep track of everything you own"
        static let tagline = "Organize your home inventory with ease"
    }
    
    struct Limits {
        static let maxItemNameLength = 100
        static let maxLocationLength = 200
        static let maxCommentLength = 500
        static let maxNoteLength = 2000
    }
}
