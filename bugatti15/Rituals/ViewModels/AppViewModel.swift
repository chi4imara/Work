import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplash = true
    @Published var hasCompletedOnboarding = false
    @Published var selectedTab: TabItem = .today
    
    init() {
        checkFirstLaunch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplash = false
            }
        }
    }
    
    private func checkFirstLaunch() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        isFirstLaunch = !hasCompletedOnboarding
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
        isFirstLaunch = false
    }
    
    func selectTab(_ tab: TabItem) {
        selectedTab = tab
    }
}

enum TabItem: String, CaseIterable {
    case today = "Today"
    case goals = "My Pleasures"
    case history = "History"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today: return "sun.max.fill"
        case .goals: return "heart.fill"
        case .history: return "calendar"
        case .settings: return "gearshape.fill"
        }
    }
}
