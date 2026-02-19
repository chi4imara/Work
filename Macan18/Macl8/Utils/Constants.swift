import Foundation

struct Constants {
    
    struct AppInfo {
        static let name = "Quote Collection"
        static let version = "1.0.0"
        static let bundleIdentifier = "com.example.quotecollection"
    }
    
    struct UserDefaultsKeys {
        static let onboardingCompleted = "OnboardingCompleted"
        static let savedQuotes = "SavedQuotes"
        static let appLaunchCount = "AppLaunchCount"
        static let lastAppVersion = "LastAppVersion"
    }
    
    struct URLs {
        static let termsOfUse = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let contactEmail = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct AnimationDuration {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 2.5
    }
    
    struct Limits {
        static let maxQuoteLength = 1000
        static let maxAuthorLength = 100
        static let maxSourceLength = 200
        static let maxCommentLength = 500
        static let searchResultsLimit = 50
    }
    
    struct SampleData {
        static let quotes = [
            (text: "Fashion fades, style is eternal.", author: "Yves Saint Laurent", source: "Interview, 1978", theme: "style"),
            (text: "Style is a way to say who you are without speaking.", author: "Rachel Zoe", source: "", theme: "style"),
            (text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt", source: "", theme: "dreams"),
            (text: "Beauty begins the moment you decide to be yourself.", author: "Coco Chanel", source: "", theme: "beauty"),
            (text: "Life is what happens to you while you're busy making other plans.", author: "John Lennon", source: "", theme: "life")
        ]
    }
}

extension Notification.Name {
    static let quoteAdded = Notification.Name("QuoteAdded")
    static let quoteUpdated = Notification.Name("QuoteUpdated")
    static let quoteDeleted = Notification.Name("QuoteDeleted")
    static let filtersChanged = Notification.Name("FiltersChanged")
}
