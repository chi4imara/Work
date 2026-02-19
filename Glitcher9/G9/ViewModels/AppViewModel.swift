import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var showSplashScreen: Bool = true
    @Published var selectedTab: Int = 0
    
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
