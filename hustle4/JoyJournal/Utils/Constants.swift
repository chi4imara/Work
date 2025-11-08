import Foundation
import SwiftUI

struct Constants {
    
    struct App {
        static let name = "Hobby Organizer"
        static let version = "1.0.0"
        static let description = "Turn your hobbies into habits with smart tracking and beautiful analytics."
    }
    
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "HasCompletedOnboarding"
        static let savedHobbies = "SavedHobbies"
        static let appLaunchCount = "AppLaunchCount"
        static let lastAppVersion = "LastAppVersion"
    }
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 2.5
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 8
        static let largeCornerRadius: CGFloat = 24
        
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        
        static let iconSize: CGFloat = 24
        static let smallIconSize: CGFloat = 16
        static let largeIconSize: CGFloat = 32
        
        static let buttonHeight: CGFloat = 50
        static let tabBarHeight: CGFloat = 80
    }
    
    struct Limits {
        static let maxCommentLength = 300
        static let maxHobbyNameLength = 50
        static let minSessionDuration = 1
        static let maxSessionDuration = 600
        static let maxHobbiesCount = 20
    }
    
    struct URLs {
        static let termsOfUse = "https://docs.google.com/document/d/13WaBv5B81HW__7XOD7fWxRACgzKE3AX4Wo0c1PhMQTg/edit?usp=sharing"
        static let privacyPolicy = "https://docs.google.com/document/d/1QRBTyKBplVRpPTOllQQVbL6B6bvZm1uS5HIUCH32RSk/edit?usp=sharing"
        static let contactUs = "https://forms.gle/YjEyyRqsRyC23Qk97"
        static let support = "https://forms.gle/YjEyyRqsRyC23Qk97"
    }
    
    struct SampleData {
        static let sampleHobbies = [
            ("Guitar Playing", "music.note"),
            ("Digital Art", "paintbrush.fill"),
            ("Reading", "book.fill"),
            ("Photography", "camera.fill"),
            ("Cooking", "leaf.fill"),
            ("Yoga", "figure.yoga"),
            ("Writing", "pencil.and.outline"),
            ("Gaming", "gamecontroller.fill")
        ]
        
        static let motivationalQuotes = [
            "Small steps lead to big changes.",
            "Consistency is the key to mastery.",
            "Every expert was once a beginner.",
            "Progress, not perfection.",
            "Your hobby today, your skill tomorrow."
        ]
    }
}

extension Constants {
    static var randomMotivationalQuote: String {
        SampleData.motivationalQuotes.randomElement() ?? SampleData.motivationalQuotes[0]
    }
    
    static var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? App.version
    }
    
    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
