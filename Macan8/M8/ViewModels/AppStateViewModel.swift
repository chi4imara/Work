import Foundation
import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var hasCompletedOnboarding = false
    @Published var isLoading = true
    @Published var selectedTab = 0
    
    init() {
        checkFirstLaunch()
        loadAppState()
    }
    
    private func checkFirstLaunch() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "HasCompletedOnboarding")
        isFirstLaunch = !hasCompletedOnboarding
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        isFirstLaunch = false
        UserDefaults.standard.set(true, forKey: "HasCompletedOnboarding")
    }
    
    func finishLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isLoading = false
            }
        }
    }
    
    private func loadAppState() {
        selectedTab = UserDefaults.standard.integer(forKey: "SelectedTab")
    }
    
    func saveSelectedTab(_ tab: Int) {
        selectedTab = tab
        UserDefaults.standard.set(tab, forKey: "SelectedTab")
    }
}
