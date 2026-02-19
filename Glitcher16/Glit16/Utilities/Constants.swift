import Foundation

struct AppConstants {
    static let appName = "Beauty Catalog"
    static let appVersion = "1.0.0"
    static let appDescription = "Organize your beauty collection with ease"
    
    struct UserDefaultsKeys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let savedProducts = "SavedProducts"
        static let showOnboarding = "showOnboarding"
    }
    
    struct URLs {
        static let privacyPolicy = "https://www.privacypolicies.com/live/33cb88ef-f0b0-4130-8d9e-a4aec4985aed"
        static let contactEmail = "https://www.privacypolicies.com/live/33cb88ef-f0b0-4130-8d9e-a4aec4985aed"
        static let appStore = "https://google.com"
    }
    
    struct AnimationDurations {
        static let short: Double = 0.3
        static let medium: Double = 0.5
        static let long: Double = 0.8
        static let splash: Double = 2.5
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
    }
    
    struct Product {
        static let maxRating = 5
        static let minRating = 1
        static let defaultRating = 5
        static let expirationWarningDays = 30
    }
}

struct SystemImages {
    static let plus = "plus"
    static let heart = "heart.fill"
    static let heartSlash = "heart.slash"
    static let folder = "folder.fill"
    static let folderBadge = "folder.badge.questionmark"
    static let star = "star"
    static let starFill = "star.fill"
    static let magnifyingGlass = "magnifyingglass"
    static let xmarkCircle = "xmark.circle.fill"
    static let chevronDown = "chevron.down"
    static let chevronRight = "chevron.right"
    static let pencil = "pencil"
    static let trash = "trash"
    static let gear = "gearshape.fill"
    static let person = "person.fill"
    static let envelope = "envelope.fill"
    static let docText = "doc.text.fill"
}
