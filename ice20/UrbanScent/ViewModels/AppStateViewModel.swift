import Foundation
import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplash = true
    @Published var showOnboarding = false
    @Published var selectedTab = 0
    
    private let dataManager = DataManager.shared
    
    init() {
        checkFirstLaunch()
        dataManager.performDataMigrationIfNeeded()
    }
    
    func checkFirstLaunch() {
        isFirstLaunch = !dataManager.hasLaunchedBefore()
        
        if isFirstLaunch {
            showOnboarding = true
        }
    }
    
    func completeSplash() {
        showSplash = false
    }
    
    func completeOnboarding() {
        showOnboarding = false
        dataManager.setHasLaunchedBefore(true)
        isFirstLaunch = false
    }
    
    func selectTab(_ index: Int) {
        selectedTab = index
    }
}
