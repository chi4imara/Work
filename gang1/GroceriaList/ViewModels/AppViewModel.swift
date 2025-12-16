import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var showSplashScreen: Bool = true
    @Published var selectedTab: Int = 0
    
    private let firstLaunchKey = "HasLaunchedBefore"
    
    init() {
        checkFirstLaunch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplashScreen = false
            }
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
        withAnimation(.easeInOut(duration: 0.5)) {
            isFirstLaunch = false
        }
    }
}
