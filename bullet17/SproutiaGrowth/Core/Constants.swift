import Foundation

struct Constants {
    
    struct App {
        static let name = "SproutiaGrowth"
        static let version = "1.0"
        static let buildNumber = "1"
    }
    
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let lastSortOption = "lastSortOption"
        static let lastFilterStatus = "lastFilterStatus"
        static let appLaunchCount = "appLaunchCount"
    }
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 4
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
    }
    
    struct Limits {
        static let maxPlantNameLength = 50
        static let maxLocationLength = 100
        static let maxNoteLength = 500
        static let maxEntriesPerPage = 20
        static let maxHeight: Double = 1000.0
        static let maxLeaves: Int32 = 10000
    }
    
    struct URLs {
        static let termsAndConditions = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let contactEmail = "https://google.com"
        static let userAgreement = "https://google.com"
    }
    
    struct Notifications {
        static let plantAdded = Notification.Name("plantAdded")
        static let entryAdded = Notification.Name("entryAdded")
        static let dataUpdated = Notification.Name("dataUpdated")
    }
}
