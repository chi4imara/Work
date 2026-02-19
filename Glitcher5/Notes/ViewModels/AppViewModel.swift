import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var showSplash = true
    @Published var showOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    @Published var selectedTab = 0
    @Published var showRecipeSaved = false
    @Published var savedRecipe: Recipe?
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        checkOnboardingStatus()
    }
    
    func completeSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplash = false
                if !self.hasSeenOnboarding() {
                    self.showOnboarding = true
                }
            }
        }
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: onboardingKey)
        withAnimation(.easeInOut(duration: 0.5)) {
            showOnboarding = true
        }
    }
    
    func showRecipeSavedScreen(recipe: Recipe) {
        savedRecipe = recipe
        showRecipeSaved = true
    }
    
    func hideRecipeSavedScreen() {
        showRecipeSaved = false
        savedRecipe = nil
        selectedTab = 0 
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func hasSeenOnboarding() -> Bool {
        return userDefaults.bool(forKey: onboardingKey)
    }
    
    private func checkOnboardingStatus() {
        if hasSeenOnboarding() {
            showOnboarding = true
        }
    }
}
