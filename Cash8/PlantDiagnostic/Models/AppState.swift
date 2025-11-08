import SwiftUI

class AppState: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showOnboarding = false
    @Published var favoriteIds: Set<String> = []
    
    init() {
        loadFavorites()
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            isFirstLaunch = true
            showOnboarding = true
        } else {
            isFirstLaunch = false
            showOnboarding = false
        }
    }
    
    func completeSplash() {
        isFirstLaunch = false
    }
    
    func completeOnboarding() {
        showOnboarding = false
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
    
    func toggleFavorite(_ plantId: String) {
        if favoriteIds.contains(plantId) {
            favoriteIds.remove(plantId)
        } else {
            favoriteIds.insert(plantId)
        }
        saveFavorites()
    }
    
    func isFavorite(_ plantId: String) -> Bool {
        favoriteIds.contains(plantId)
    }
    
    private func saveFavorites() {
        let array = Array(favoriteIds)
        UserDefaults.standard.set(array, forKey: "favoriteIds")
    }
    
    private func loadFavorites() {
        let array = UserDefaults.standard.array(forKey: "favoriteIds") as? [String] ?? []
        favoriteIds = Set(array)
    }
}

