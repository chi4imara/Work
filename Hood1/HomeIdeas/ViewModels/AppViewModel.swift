import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var isOnboardingComplete = false
    @Published var selectedTab = 0
    @Published var showingSidebar = false
    @Published var showingAddIdea = false
    @Published var showingAddCategory = false
    @Published var showingRandomIdea = false
    @Published var showingHistoryFilter = false
    
    init() {
        checkOnboardingStatus()
        simulateLoading()
    }
    
    private func checkOnboardingStatus() {
        isOnboardingComplete = UserDefaults.standard.bool(forKey: "OnboardingComplete")
    }
    
    func completeOnboarding() {
        print("AppViewModel: Completing onboarding")
        isOnboardingComplete = true
        UserDefaults.standard.set(true, forKey: "OnboardingComplete")
        print("AppViewModel: Onboarding completed, isOnboardingComplete = \(isOnboardingComplete)")
    }
    
    private func simulateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isLoading = false
            }
        }
    }
    
    func toggleSidebar() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            showingSidebar.toggle()
        }
    }
}
