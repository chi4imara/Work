import Foundation
import SwiftUI
import Combine

enum SortOption: String, CaseIterable {
    case lastCleaned = "By last cleaning date"
    case alphabetical = "Alphabetically"
    case category = "By category"
}

class CleaningZoneViewModel: ObservableObject {
    @Published var zones: [CleaningZone] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var searchText = ""
    @Published var sortOption: SortOption = .lastCleaned
    @Published var showingOnboarding = true
    
    private let zonesKey = Constants.UserDefaultsKeys.savedZones
    private let categoriesKey = Constants.UserDefaultsKeys.savedCategories
    private let onboardingKey = Constants.UserDefaultsKeys.hasSeenOnboarding
    
    init() {
        loadData()
    }
    
    var filteredAndSortedZones: [CleaningZone] {
        let filtered = searchText.isEmpty ? zones : zones.filter { zone in
            zone.name.localizedCaseInsensitiveContains(searchText) ||
            zone.category.localizedCaseInsensitiveContains(searchText)
        }
        
        switch sortOption {
        case .lastCleaned:
            return filtered.sorted { zone1, zone2 in
                guard let date1 = zone1.lastCleanedDate else { return false }
                guard let date2 = zone2.lastCleanedDate else { return true }
                return date1 > date2
            }
        case .alphabetical:
            return filtered.sorted { $0.name < $1.name }
        case .category:
            return filtered.sorted { $0.category < $1.category }
        }
    }
    
    func addZone(_ zone: CleaningZone) {
        zones.append(zone)
        saveData()
    }
    
    func updateZone(_ zone: CleaningZone) {
        if let index = zones.firstIndex(where: { $0.id == zone.id }) {
            zones[index] = zone
            saveData()
        }
    }
    
    func deleteZone(_ zone: CleaningZone) {
        zones.removeAll { $0.id == zone.id }
        saveData()
    }
    
    func toggleZoneCompletion(_ zone: CleaningZone) {
        if let index = zones.firstIndex(where: { $0.id == zone.id }) {
            zones[index].isCompleted.toggle()
            zones[index].lastCleanedDate = zones[index].isCompleted ? Date() : nil
            saveData()
        }
    }
    
    func deleteAllZones() {
        zones.removeAll()
        saveData()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        saveCategories()
    }
    
    func completeOnboarding() {
        showingOnboarding = false
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(zones) {
            UserDefaults.standard.set(encoded, forKey: zonesKey)
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        showingOnboarding = !UserDefaults.standard.bool(forKey: onboardingKey)
        
        if let data = UserDefaults.standard.data(forKey: zonesKey),
           let decodedZones = try? JSONDecoder().decode([CleaningZone].self, from: data) {
            zones = decodedZones
        }
        
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decodedCategories
        }
    }
}
