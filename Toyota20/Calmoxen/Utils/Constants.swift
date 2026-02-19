import Foundation
import SwiftUI

struct AppConstants {
    static let appName = "Evening Rest"
    static let appVersion = "1.0.0"
    static let releaseDate = "February 2026"
    
    static let privacyPolicyURL = "https://google.com"
    static let contactURL = "https://google.com"
    static let supportURL = "https://google.com"
    
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "HasCompletedOnboarding"
        static let savedPractices = "SavedPractices"
        static let savedHistory = "SavedHistory"
        static let savedStreak = "SavedStreak"
        static let lastAppVersion = "LastAppVersion"
    }
    
    struct AnimationDurations {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 20
        static let shadowRadius: CGFloat = 8
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 12
        static let tabBarHeight: CGFloat = 80
    }
    
    struct PracticeLimits {
        static let minDuration = 1
        static let maxDuration = 60
        static let maxNameLength = 50
        static let maxCommentLength = 200
    }
    
    static let eveningTips = [
        "Take deep breaths to activate your parasympathetic nervous system",
        "Gentle stretching helps release physical tension from the day",
        "Meditation can reduce cortisol levels and improve sleep quality",
        "Light movement promotes better circulation and relaxation",
        "Consistency is key - even 5 minutes daily makes a difference",
        "Create a peaceful environment for your evening practice",
        "Focus on letting go of the day's stress and worries",
        "Progressive muscle relaxation can help prepare your body for rest"
    ]
    
    static let practiceIdeas = [
        "4-7-8 Breathing Technique",
        "Gentle Neck and Shoulder Rolls",
        "Body Scan Meditation",
        "Light Yoga Stretches",
        "Gratitude Reflection",
        "Progressive Muscle Relaxation",
        "Mindful Walking",
        "Calming Visualization"
    ]
}

extension AppConstants {
    static func randomTip() -> String {
        eveningTips.randomElement() ?? eveningTips[0]
    }
    
    static func randomPracticeIdea() -> String {
        practiceIdeas.randomElement() ?? practiceIdeas[0]
    }
}
