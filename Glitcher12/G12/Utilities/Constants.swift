import Foundation

struct Constants {
    struct UserDefaults {
        static let manicuresKey = "SavedManicures"
        static let mastersKey = "SavedMasters"
        static let firstLaunchKey = "IsFirstLaunch"
    }
    
    struct URLs {
        static let privacyPolicy = "https://www.privacypolicies.com/live/2f2343e1-c6d7-4bab-a69c-f1cf6bf9b497"
        static let contactUs = "https://www.privacypolicies.com/live/2f2343e1-c6d7-4bab-a69c-f1cf6bf9b497"
        static let termsOfService = "https://google.com"
    }
    
    struct App {
        static let name = "Manicure Diary"
        static let version = "1.0.0"
        static let description = "Keep your nail designs organized"
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let splashDuration: Double = 3.0
    }
}
