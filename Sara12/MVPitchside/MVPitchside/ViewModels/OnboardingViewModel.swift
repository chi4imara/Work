import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var showMainApp = false
    
    private let userDefaults = UserDefaults.standard
    private let hasSeenOnboardingKey = "HasSeenOnboarding"
    
    var hasSeenOnboarding: Bool {
        get {
            userDefaults.bool(forKey: hasSeenOnboardingKey)
        }
        set {
            userDefaults.set(newValue, forKey: hasSeenOnboardingKey)
        }
    }
    
    let onboardingPages = [
        OnboardingPage(
            title: "Record Your Matches. Keep the Memories.",
            description: "This app is designed for amateur players who want to keep track of their games. Log each match with the date, score, and the best player of the day.",
            imageName: "sportscourt"
        ),
        OnboardingPage(
            title: "Track Your Progress",
            description: "Over time, you'll build a personal archive of your matches that shows not just numbers, but also your memorable moments.",
            imageName: "chart.bar"
        ),
        OnboardingPage(
            title: "Simple and Clear",
            description: "It's simple, clear, and made for those who enjoy the game as much as the results. With your match diary, every game stays with you.",
            imageName: "list.bullet.clipboard"
        )
    ]
    
    func nextPage() {
        if currentPage < onboardingPages.count - 1 {
            currentPage += 1
        } else {
            completeOnboarding()
        }
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        showMainApp = true
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}
