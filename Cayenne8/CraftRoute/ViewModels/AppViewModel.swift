import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplash = true
    @Published var showOnboarding = false
    @Published var selectedTab = 0
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "HasLaunchedBefore"
    
    init() {
        checkFirstLaunch()
        setupSplashTimer()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    private func setupSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.showSplash = false
            if self.isFirstLaunch {
                self.showOnboarding = true
            }
        }
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        isFirstLaunch = false
        showOnboarding = false
    }
    
    func selectTab(_ index: Int) {
        selectedTab = index
    }
}
