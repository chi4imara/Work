import Foundation

struct Constants {
    struct UserDefaults {
        static let storiesKey = "saved_stories"
        static let sortOptionKey = "sort_option"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 4
        static let buttonHeight: CGFloat = 50
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let splashDuration: Double = 3.0
        static let loadingRotationDuration: Double = 1.5
        static let pulseDuration: Double = 2.0
    }
    
    struct TextLimits {
        static let titleMaxLength = 100
        static let previewMaxLength = 100
        static let tagMaxLength = 20
        static let maxTagsPerStory = 10
    }
    
    struct PopularTags {
        static let list = ["work", "school", "travel", "family", "friends", "hobby", "health", "food"]
    }
    
    struct URLs {
        static let termsOfUse = "https://docs.google.com/document/d/1bgWfnFvXk9n0A7AJ4iy5ty5AvGCSWZkPH8ln5zeOwCA/edit?usp=sharing"
        static let privacyPolicy = "https://docs.google.com/document/d/15xSi7jEn0m4i-Azy11HqiskgyVUXdjoW4-jMz45dUUI/edit?usp=sharing"
        static let contactEmail = "https://forms.gle/KzoDVEnDm4xL8Zt97"
        static let userAgreement = "https://google.com"
        static let emailSupport = "https://google.com"
    }
}
