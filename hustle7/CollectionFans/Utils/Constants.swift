import Foundation

struct AppConstants {
    static let appName = "Collection Manager"
    static let version = "1.0.0"
    
    static let hasSeenOnboardingKey = "HasSeenOnboarding"
    static let savedCollectionsKey = "SavedCollections"
    
    static let maxCollectionNameLength = 50
    static let maxCollectionDescriptionLength = 200
    static let maxItemNameLength = 50
    static let maxItemDescriptionLength = 300
    static let maxItemNotesLength = 200
    
    static let shortAnimationDuration: Double = 0.2
    static let mediumAnimationDuration: Double = 0.3
    static let longAnimationDuration: Double = 0.5
    
    static let cardCornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 8
    static let iconSize: CGFloat = 24
    static let smallIconSize: CGFloat = 16
    static let largeIconSize: CGFloat = 40
}
