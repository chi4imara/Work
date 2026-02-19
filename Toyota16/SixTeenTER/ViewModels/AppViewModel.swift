import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplashScreen = true
    @Published var currentTab: TabItem = .today
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "isFirstLaunch"
    
    init() {
        checkFirstLaunch()
        setupSplashScreenTimer()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    private func setupSplashScreenTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplashScreen = false
            }
        }
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        withAnimation(.easeInOut(duration: 0.5)) {
            isFirstLaunch = false
        }
    }
    
    func switchTab(to tab: TabItem) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentTab = tab
        }
    }
}

enum TabItem: String, CaseIterable {
    case today = "Today"
    case tasks = "My Tasks"
    case statistics = "Statistics"
    case history = "History"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .today:
            return "house.fill"
        case .tasks:
            return "list.bullet"
        case .statistics:
            return "chart.bar.fill"
        case .history:
            return "calendar"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
}