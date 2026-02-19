import Foundation
import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var hasCompletedOnboarding = false
    
    private let onboardingKey = "HasCompletedOnboarding"
    
    let pages = [
        OnboardingPage(
            title: "Reduce Stress After Work",
            description: "Light practices will help you relax, relieve fatigue and restore strength.",
            imageName: "figure.mind.and.body"
        ),
        OnboardingPage(
            title: "Find Your Rhythm",
            description: "Add short evening practices, track their completion and monitor progress.",
            imageName: "heart.text.square"
        ),
        OnboardingPage(
            title: "Personal Recovery Diary",
            description: "All practices and notes will be stored locally, without unnecessary notifications and integrations.",
            imageName: "book.closed"
        )
    ]
    
    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    func nextPage() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage += 1
            }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage -= 1
            }
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}
