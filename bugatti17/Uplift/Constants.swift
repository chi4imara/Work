import SwiftUI

struct DesignConstants {
    struct Colors {
        static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
        static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
        static let white = Color.white
        static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
        static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
        static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
        static let lightGreen = Color(red: 0.7, green: 0.9, blue: 0.7)
        static let softPurple = Color(red: 0.8, green: 0.7, blue: 1.0)
        static let gradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
        static let gradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    }
    
    struct Fonts {
        static let largeTitle: CGFloat = 34
        static let title: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption: CGFloat = 12
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let slowDuration: Double = 0.6
        static let fastDuration: Double = 0.15
    }
}

struct AppConstants {
    static let appName = "Energy Day"
    
    struct Onboarding {
        static let screens = [
            OnboardingScreen(
                title: "Start Your Day with Yourself",
                description: "Track your mood, complete mini-tasks and take care of yourself every day."
            ),
            OnboardingScreen(
                title: "Small Steps, Big Energy",
                description: "Add habits, record rituals and feel the progress."
            ),
            OnboardingScreen(
                title: "Let's Get Started",
                description: "Interactive tasks, support and visual rewards are waiting for you."
            )
        ]
    }
    
    static let moodOptions = [
        MoodOption(id: "happy", name: "Happy", icon: "face.smiling"),
        MoodOption(id: "excited", name: "Excited", icon: "star.fill"),
        MoodOption(id: "calm", name: "Calm", icon: "leaf.fill"),
        MoodOption(id: "tired", name: "Tired", icon: "moon.fill"),
        MoodOption(id: "stressed", name: "Stressed", icon: "exclamationmark.triangle.fill"),
        MoodOption(id: "sad", name: "Sad", icon: "cloud.rain.fill"),
        MoodOption(id: "motivated", name: "Motivated", icon: "flame.fill")
    ]
    
    static let habitCategories = [
        HabitCategory(id: "body", name: "Body", icon: "figure.walk"),
        HabitCategory(id: "mind", name: "Mind", icon: "brain.head.profile"),
        HabitCategory(id: "hobby", name: "Hobby", icon: "paintbrush.fill"),
        HabitCategory(id: "social", name: "Social", icon: "person.2.fill"),
        HabitCategory(id: "other", name: "Other", icon: "ellipsis.circle.fill")
    ]
    
    static let dailyQuestions = [
        "What will bring you joy today?",
        "What are you grateful for right now?",
        "What small step will you take towards your goal?",
        "How do you want to feel at the end of the day?",
        "What would make today special?",
        "What energy do you want to share with the world?",
        "What will you do to take care of yourself today?"
    ]
    
    static let defaultMiniChallenges = [
        MiniChallenge(
            id: UUID(),
            title: "Write 1 gratitude",
            description: "Think of something you're grateful for today",
            category: "mind"
        ),
        MiniChallenge(
            id: UUID(),
            title: "5-minute meditation",
            description: "Take a moment to breathe and relax",
            category: "mind"
        ),
        MiniChallenge(
            id: UUID(),
            title: "Drink a glass of water",
            description: "Hydrate your body",
            category: "body"
        ),
        MiniChallenge(
            id: UUID(),
            title: "Send a kind message",
            description: "Reach out to someone you care about",
            category: "social"
        )
    ]
}

struct OnboardingScreen {
    let title: String
    let description: String
}

struct MoodOption: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
}

struct HabitCategory: Identifiable {
    let id: String
    let name: String
    let icon: String
}
