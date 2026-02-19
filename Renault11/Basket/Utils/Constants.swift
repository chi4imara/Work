import Foundation

struct Constants {
    struct App {
        static let name = "Shopping Energy"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let support = "https://google.com"
        static let website = "https://google.com"
        static let faq = "https://google.com"
    }
    
    struct UserDefaults {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let dailyBudgetLimit = "dailyBudgetLimit"
        static let lastOpenDate = "lastOpenDate"
    }
    
    struct Animation {
        static let defaultDuration = 0.3
        static let longDuration = 0.5
        static let shortDuration = 0.15
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let largeCornerRadius: CGFloat = 20
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let smallButtonHeight: CGFloat = 44
    }
    
    struct Budget {
        static let defaultDailyLimit: Double = 1000.0
        static let minimumLimit: Double = 10.0
        static let maximumLimit: Double = 10000.0
    }
    
    struct Purchase {
        static let minimumAmount: Double = 0.01
        static let maximumAmount: Double = 99999.99
        static let maxNameLength = 50
        static let maxNotesLength = 200
    }
}