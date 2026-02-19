import Foundation

struct AppConstants {
    static let appName = "Gratitude & Joy Diary"
    static let appDescription = "Your daily companion for mindfulness and positivity"
    
    struct UserDefaultsKeys {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let habits = "habits"
        static let dailyEntryPrefix = "dailyEntry_"
        static let userSettings = "userSettings"
    }
    
    struct URLs {
        static let privacyPolicy = "https://google.com"
        static let contactEmail = "https://google.com"
        static let appStore = "https://google.com"
    }
    
    struct Limits {
        static let maxMoodsPerDay = 3
        static let maxGratitudeEntries = 10
        static let maxHabitNameLength = 50
        static let maxGratitudeTextLength = 200
        static let maxQuestionAnswerLength = 300
    }
    
    struct Defaults {
        static let defaultHabits = [
            "Morning walk",
            "Meditation",
            "Breathing practice",
            "Reading",
            "Journaling"
        ]
        
        static let motivationalMessages = [
            "You're wonderful!",
            "You're amazing!",
            "Keep going!",
            "You're doing great!",
            "Proud of you!",
            "You're incredible!",
            "Well done!",
            "You're awesome!"
        ]
    }
    
    struct AnimationDurations {
        static let quick: Double = 0.2
        static let medium: Double = 0.4
        static let slow: Double = 0.6
        static let splash: Double = 2.0
        static let celebration: Double = 2.0
    }
}
