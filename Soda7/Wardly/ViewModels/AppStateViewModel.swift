import Foundation
import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isLoading: Bool = true
    @Published var selectedTab: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "HasCompletedOnboarding"
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        checkFirstLaunch()
        checkOnboardingStatus()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func completeFirstLaunch() {
        isFirstLaunch = false
        userDefaults.set(false, forKey: firstLaunchKey)
    }
    
    func finishLoading() {
        isLoading = false
    }
    
    func selectTab(_ index: Int) {
        selectedTab = index
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = userDefaults.object(forKey: firstLaunchKey) == nil
    }
    
    private func checkOnboardingStatus() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        userDefaults.removeObject(forKey: onboardingKey)
    }
    
    func resetFirstLaunch() {
        isFirstLaunch = true
        userDefaults.removeObject(forKey: firstLaunchKey)
    }
}
