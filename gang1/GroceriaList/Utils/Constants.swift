import Foundation

struct Constants {
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let splashDuration: Double = 3.0
        static let orbAnimationRange = 3.0...6.0
    }
    
    struct Layout {
        static let defaultPadding: CGFloat = 20
        static let cardCornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 25
        static let tabBarHeight: CGFloat = 80
    }
    
    struct UserDefaults {
        static let hasLaunchedBefore = "HasLaunchedBefore"
        static let savedProducts = "SavedProducts"
        static let savedCategories = "SavedCategories"
    }
    
    struct URLs {
        static let defaultURL = "https://google.com"
    }
}
