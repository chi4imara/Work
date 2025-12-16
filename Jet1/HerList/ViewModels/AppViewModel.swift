import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplash = true
    @Published var selectedTab = 0
    
    init() {
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
    }
    
    func completedOnboarding() {
        UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
        isFirstLaunch = false
    }
    
    func completedSplash() {
        showSplash = false
    }
}
