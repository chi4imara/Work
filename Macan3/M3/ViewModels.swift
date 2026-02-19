import Foundation
import SwiftUI
import StoreKit
import Combine

class FragranceViewModel: ObservableObject {
    @Published var fragrances: [Fragrance] = []
    @Published var filteredFragrances: [Fragrance] = []
    @Published var searchText: String = ""
    @Published var currentFilter = FragranceFilter()
    @Published var sortOption: SortOption = .dateAdded
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let fragrancesKey = "SavedFragrances"
    
    init() {
        loadFragrances()
        updateFilteredFragrances()
    }
    
    func saveFragrances() {
        if let encoded = try? JSONEncoder().encode(fragrances) {
            userDefaults.set(encoded, forKey: fragrancesKey)
        }
    }
    
    func loadFragrances() {
        if let data = userDefaults.data(forKey: fragrancesKey),
           let decoded = try? JSONDecoder().decode([Fragrance].self, from: data) {
            fragrances = decoded
        }
    }
    
    func addFragrance(_ fragrance: Fragrance) {
        fragrances.append(fragrance)
        saveFragrances()
        updateFilteredFragrances()
    }
    
    func updateFragrance(_ fragrance: Fragrance) {
        if let index = fragrances.firstIndex(where: { $0.id == fragrance.id }) {
            fragrances[index] = fragrance
            saveFragrances()
            updateFilteredFragrances()
        }
    }
    
    func deleteFragrance(_ fragrance: Fragrance) {
        fragrances.removeAll { $0.id == fragrance.id }
        saveFragrances()
        updateFilteredFragrances()
    }
    
    func updateFilteredFragrances() {
        var result = fragrances
        
        if !searchText.isEmpty {
            result = result.filter { fragrance in
                fragrance.name.localizedCaseInsensitiveContains(searchText) ||
                fragrance.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        result = result.filter { fragrance in
            currentFilter.types.contains(fragrance.type) &&
            currentFilter.seasons.contains(fragrance.season) &&
            (currentFilter.brands.isEmpty || currentFilter.brands.contains(fragrance.brand)) &&
            (currentFilter.atmospheres.isEmpty || currentFilter.atmospheres.contains(fragrance.atmosphere))
        }
        
        switch sortOption {
        case .brand:
            result.sort { $0.brand < $1.brand }
        case .type:
            result.sort { $0.type.rawValue < $1.type.rawValue }
        case .season:
            result.sort { $0.season.rawValue < $1.season.rawValue }
        case .dateAdded:
            result.sort { $0.dateAdded > $1.dateAdded }
        }
        
        filteredFragrances = result
    }
    
    func applyFilter(_ filter: FragranceFilter) {
        currentFilter = filter
        updateFilteredFragrances()
    }
    
    func resetFilter() {
        currentFilter.reset()
        updateFilteredFragrances()
    }
    
    func fragrancesForSeason(_ season: Season) -> [Fragrance] {
        return fragrances.filter { $0.season == season }
    }
    
    func getAllBrands() -> [String] {
        return Array(Set(fragrances.map { $0.brand })).sorted()
    }
    
    func getAllAtmospheres() -> [String] {
        return Array(Set(fragrances.map { $0.atmosphere })).sorted()
    }
}

class AppViewModel: ObservableObject {
    @Published var currentTab: TabItem = .collection
    @Published var showOnboarding = false
    @Published var isFirstLaunch = true
    @Published var showSplash = true
    
    private let userDefaults = UserDefaults.standard
    private let hasLaunchedKey = "HasLaunchedBefore"
    
    init() {
        checkFirstLaunch()
    }
    
    func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: hasLaunchedKey)
        showOnboarding = isFirstLaunch
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: hasLaunchedKey)
        showOnboarding = false
        isFirstLaunch = false
    }
    
    func hideSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplash = false
            }
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

enum TabItem: String, CaseIterable {
    case collection = "Collection"
    case seasons = "Seasons"
    case filters = "Filters"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .collection: return "square.grid.2x2"
        case .seasons: return "calendar"
        case .filters: return "line.3.horizontal.decrease.circle"
        case .settings: return "gearshape"
        case .statistics: return "chart.bar"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .collection: return "square.grid.2x2.fill"
        case .seasons: return "calendar"
        case .filters: return "line.3.horizontal.decrease.circle.fill"
        case .settings: return "gearshape.fill"
        case .statistics: return "chart.bar.fill"
        }
    }
}
