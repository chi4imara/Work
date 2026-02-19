import Foundation

struct Constants {
    
    struct App {
        static let name = "Fitness Tracker"
        static let version = "1.0.0"
        static let minimumIOSVersion = "16.0"
    }
    
    struct UserDefaultsKeys {
        static let isFirstLaunch = "isFirstLaunch"
        static let phases = "phases"
        static let hasSeenOnboarding = "hasSeenOnboarding"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let termsOfUse = "https://google.com"
        static let contactUs = "https://google.com"
        static let dataProtection = "https://google.com"
        static let helpCenter = "https://google.com"
        static let feedback = "https://google.com"
    }
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let cardPadding: CGFloat = 20
        static let screenPadding: CGFloat = 20
    }
    
    struct WorkoutTypes {
        static let suggestions = [
            "Chest", "Back", "Legs", "Shoulders", "Arms",
            "Cardio", "Core", "Full Body", "HIIT", "Yoga",
            "Strength", "Endurance", "Flexibility"
        ]
    }
}
