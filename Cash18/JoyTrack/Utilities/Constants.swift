import Foundation

struct AppConstants {
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let savedEvents = "SavedEvents"
        static let selectedEventTypes = "SelectedEventTypes"
        static let sortOption = "SortOption"
    }
    
    struct Validation {
        static let maxTitleLength = 60
        static let maxNoteLength = 500
        static let maxGiftIdeas = 10
    }
    
    struct AnimationDuration {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 2.5
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let itemSpacing: CGFloat = 12
        static let tabBarHeight: CGFloat = 80
    }
    
    struct URLs {
        static let privacyPolicy = "https://docs.google.com/document/d/1oS-bJ9cywoZAK32IVBXCNWHJ132wG6oqhpp-dCX-jnU/edit?usp=sharing"
        static let termsOfUse = "https://docs.google.com/document/d/1AnL2nbmco3qvqqhFz38kl-4ryUwk4OYdqOkyVflra7k/edit?usp=sharing"
        static let contactEmail = "https://forms.gle/2496j3ArFRteWZAv6"
        static let appStore = "https://google.com"
    }
    
    struct AppInfo {
        static let name = "Holiday Calendar"
        static let version = "1.0.0"
        static let buildNumber = "1"
    }
}
