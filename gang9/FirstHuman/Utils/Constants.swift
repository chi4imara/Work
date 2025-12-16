import Foundation

struct Constants {
    struct UserDefaults {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let dailyAnswers = "dailyAnswers"
        static let personalNotes = "personalNotes"
    }
    
    struct URLs {
        static let termsOfService = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let contactUs = "https://google.com"
        static let licenseAgreement = "https://google.com"
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let splashDuration: Double = 2.5
        static let confirmationDuration: Double = 2.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 15
        static let cardCornerRadius: CGFloat = 20
        static let buttonCornerRadius: CGFloat = 25
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 12
    }
}
