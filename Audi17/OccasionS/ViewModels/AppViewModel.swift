import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplashScreen = true
    @Published var selectedTab = 0
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        checkFirstLaunch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplashScreen = false
            }
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        withAnimation(.easeInOut(duration: 0.5)) {
            isFirstLaunch = false
        }
    }
    
    func selectTab(_ index: Int) {
        selectedTab = index
    }
}
