import SwiftUI
import Foundation
import Combine

class AppStateManager: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showingSplash = true
    @Published var currentTab: AppTab = .calendar
    @Published var selectedDate: Date = Date()
    @Published var showingColorPicker = false
    @Published var showingDayDetails = false
    @Published var showingSettings = false
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "first_launch"
    
    init() {
        checkFirstLaunch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showingSplash = false
            }
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        withAnimation(.easeInOut) {
            isFirstLaunch = false
        }
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    func showColorPicker(for date: Date) {
        showingDayDetails = false
        selectedDate = date
        showingColorPicker = true
    }
    
    func showDayDetails(for date: Date) {
        showingColorPicker = false
        selectedDate = date
        showingDayDetails = true
    }
    
    func dismissColorPicker() {
        showingColorPicker = false
    }
    
    func dismissDayDetails() {
        showingDayDetails = false
    }
}

enum AppTab: String, CaseIterable {
    case calendar = "Calendar"
    case list = "List"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .calendar: return "calendar"
        case .list: return "list.bullet"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        }
    }
    
    var title: String {
        return rawValue
    }
}
