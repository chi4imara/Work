import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var showSplash: Bool = true
    @Published var selectedTab: Int = 0
    @Published var isTabBarHidden: Bool = false
    
    private var detailViewCount: Int = 0 {
        didSet {
            isTabBarHidden = detailViewCount > 0
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "isFirstLaunch"
    
    func enterDetailView() {
        detailViewCount += 1
    }
    
    func exitDetailView() {
        detailViewCount = max(0, detailViewCount - 1)
    }
    
    init() {
        checkFirstLaunch()
        setupSplashTimer()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        isFirstLaunch = false
    }
    
    private func setupSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplash = false
            }
        }
    }
    
    func selectTab(_ index: Int) {
        selectedTab = index
    }
}
