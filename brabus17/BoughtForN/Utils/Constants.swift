import Foundation

struct Constants {
    struct UserDefaults {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let savedPurchases = "SavedPurchases"
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let springResponse: Double = 0.8
        static let springDamping: Double = 0.6
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
    }
}