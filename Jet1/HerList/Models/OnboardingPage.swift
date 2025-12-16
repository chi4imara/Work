import Foundation

struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

extension OnboardingPage {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "heart.text.square.fill",
            title: "Collect your daily inspiration.",
            description: "Build your own gallery of inspiring women — from artists and leaders to designers and creators. Save names, quotes, and personal notes that move you forward."
        ),
        OnboardingPage(
            icon: "quote.bubble.fill",
            title: "Save inspiring quotes.",
            description: "Every entry becomes a reminder of strength, talent, and individuality. Capture the words that resonate with you and keep them close."
        ),
        OnboardingPage(
            icon: "star.fill",
            title: "Your personal motivation.",
            description: "Your pocket-sized source of motivation — always close, always yours. Build a collection that inspires you every day."
        )
    ]
}
