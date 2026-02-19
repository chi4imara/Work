import Foundation
import SwiftUI
import Combine

class NavigationViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .combinations
    @Published var showSplashScreen = true
    @Published var isOnboardingCompleted = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "OnboardingCompleted"
    
    init() {
        checkOnboardingStatus()
    }
    
    func selectTab(_ tab: TabItem) {
        selectedTab = tab
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func hideSplashScreen() {
        showSplashScreen = false
    }
    
    private func checkOnboardingStatus() {
        isOnboardingCompleted = userDefaults.bool(forKey: onboardingKey)
    }
}

enum TabItem: String, CaseIterable {
    case combinations = "Combinations"
    case selection = "Selection"
    case favorites = "Favorites"
    case trends = "Trends"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .combinations:
            return "square.grid.2x2"
        case .selection:
            return "wand.and.stars"
        case .favorites:
            return "heart"
        case .trends:
            return "chart.line.uptrend.xyaxis"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .combinations:
            return "square.grid.2x2.fill"
        case .selection:
            return "wand.and.stars.inverse"
        case .favorites:
            return "heart.fill"
        case .trends:
            return "chart.line.uptrend.xyaxis"
        case .settings:
            return "gearshape.fill"
        }
    }
}
