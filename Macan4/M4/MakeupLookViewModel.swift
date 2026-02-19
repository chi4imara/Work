import SwiftUI
import Foundation
import Combine

class MakeupLookViewModel: ObservableObject {
    @Published var makeupLooks: [MakeupLook] = []
    @Published var filteredLooks: [MakeupLook] = []
    @Published var searchText: String = ""
    @Published var filterOptions = FilterOptions()
    @Published var sortOption: SortOption = .dateCreated
    @Published var isShowingOnboarding: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let makeupLooksKey = "SavedMakeupLooks"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadMakeupLooks()
        loadOnboardingStatus()
        updateFilteredLooks()
    }
    
    private func saveMakeupLooks() {
        if let encoded = try? JSONEncoder().encode(makeupLooks) {
            userDefaults.set(encoded, forKey: makeupLooksKey)
        }
    }
    
    private func loadMakeupLooks() {
        if let data = userDefaults.data(forKey: makeupLooksKey),
           let decoded = try? JSONDecoder().decode([MakeupLook].self, from: data) {
            makeupLooks = removeDuplicates(from: decoded)
            saveMakeupLooks()
        }
    }
    
    private func removeDuplicates(from looks: [MakeupLook]) -> [MakeupLook] {
        var seenIDs = Set<UUID>()
        var uniqueLooks: [MakeupLook] = []
        
        for look in looks {
            if !seenIDs.contains(look.id) {
                seenIDs.insert(look.id)
                uniqueLooks.append(look)
            }
        }
        
        return uniqueLooks
    }
    
    private func loadOnboardingStatus() {
        isShowingOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        isShowingOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func addMakeupLook(_ look: MakeupLook) {
        if !makeupLooks.contains(where: { $0.id == look.id }) {
            makeupLooks.append(look)
            saveMakeupLooks()
            updateFilteredLooks()
        }
    }
    
    func updateMakeupLook(_ look: MakeupLook) {
        if let index = makeupLooks.firstIndex(where: { $0.id == look.id }) {
            makeupLooks[index] = look
            saveMakeupLooks()
            updateFilteredLooks()
        }
    }
    
    func deleteMakeupLook(_ look: MakeupLook) {
        makeupLooks.removeAll { $0.id == look.id }
        saveMakeupLooks()
        updateFilteredLooks()
    }
    
    func toggleFavorite(for look: MakeupLook) {
        if let index = makeupLooks.firstIndex(where: { $0.id == look.id }) {
            makeupLooks[index].isFavorite.toggle()
            saveMakeupLooks()
            updateFilteredLooks()
        }
    }
    
    func updateFilteredLooks() {
        makeupLooks = removeDuplicates(from: makeupLooks)
        var filtered = makeupLooks
        
        if !searchText.isEmpty {
            filtered = filtered.filter { look in
                look.name.localizedCaseInsensitiveContains(searchText) ||
                look.category.displayName.localizedCaseInsensitiveContains(searchText) ||
                look.notes.localizedCaseInsensitiveContains(searchText) ||
                look.products.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !filterOptions.selectedCategories.isEmpty {
            filtered = filtered.filter { filterOptions.selectedCategories.contains($0.category) }
        }
        
        if !filterOptions.selectedColors.isEmpty {
            filtered = filtered.filter { look in
                !Set(look.colors).isDisjoint(with: filterOptions.selectedColors)
            }
        }
        
        if filterOptions.showOnlyFavorites {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        switch sortOption {
        case .dateCreated:
            filtered.sort { $0.dateCreated > $1.dateCreated }
        case .name:
            filtered.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .category:
            filtered.sort { $0.category.displayName.localizedCaseInsensitiveCompare($1.category.displayName) == .orderedAscending }
        case .favorites:
            filtered.sort { $0.isFavorite && !$1.isFavorite }
        }
        
        filteredLooks = filtered
    }
    
    func applyFilters() {
        updateFilteredLooks()
    }
    
    func resetFilters() {
        filterOptions.reset()
        updateFilteredLooks()
    }
    
    func getLooksCount(for category: MakeupCategory) -> Int {
        return makeupLooks.filter { $0.category == category }.count
    }
    
    func getLooksForCategory(_ category: MakeupCategory) -> [MakeupLook] {
        return makeupLooks.filter { $0.category == category }
    }
    
    func performSearch() {
        updateFilteredLooks()
    }
    
    func clearSearch() {
        searchText = ""
        updateFilteredLooks()
    }
    
    func getLook(by id: UUID) -> MakeupLook? {
        return makeupLooks.first { $0.id == id }
    }
    
    func toggleFavorite(by id: UUID) {
        if let index = makeupLooks.firstIndex(where: { $0.id == id }) {
            makeupLooks[index].isFavorite.toggle()
            saveMakeupLooks()
            updateFilteredLooks()
        }
    }
    
    func deleteMakeupLook(by id: UUID) {
        makeupLooks.removeAll { $0.id == id }
        saveMakeupLooks()
        updateFilteredLooks()
    }
}
