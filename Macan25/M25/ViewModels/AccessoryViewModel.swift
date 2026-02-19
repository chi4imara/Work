import Foundation
import SwiftUI
import Combine

class AccessoryViewModel: ObservableObject {
    @Published var accessories: [Accessory] = []
    @Published var filteredAccessories: [Accessory] = []
    @Published var searchText: String = ""
    @Published var selectedTypes: Set<AccessoryType> = []
    @Published var selectedStatuses: Set<AccessoryStatus> = []
    @Published var isFiltered: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let accessoriesKey = "SavedAccessories"
    
    init() {
        loadAccessories()
        filteredAccessories = accessories
    }
        
    func addAccessory(_ accessory: Accessory) {
        accessories.append(accessory)
        saveAccessories()
        applyFilters()
    }
    
    func updateAccessory(_ accessory: Accessory) {
        if let index = accessories.firstIndex(where: { $0.id == accessory.id }) {
            accessories[index] = accessory
            saveAccessories()
            applyFilters()
        }
    }
    
    func deleteAccessory(_ accessory: Accessory) {
        accessories.removeAll { $0.id == accessory.id }
        saveAccessories()
        applyFilters()
    }
        
    func applyFilters() {
        var result = accessories
        
        if !searchText.isEmpty {
            result = result.filter { accessory in
                accessory.name.localizedCaseInsensitiveContains(searchText) ||
                accessory.type.displayName.localizedCaseInsensitiveContains(searchText) ||
                accessory.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedTypes.isEmpty {
            result = result.filter { selectedTypes.contains($0.type) }
        }
        
        if !selectedStatuses.isEmpty {
            result = result.filter { selectedStatuses.contains($0.status) }
        }
        
        filteredAccessories = result
        isFiltered = !searchText.isEmpty || !selectedTypes.isEmpty || !selectedStatuses.isEmpty
    }
    
    func clearFilters() {
        searchText = ""
        selectedTypes.removeAll()
        selectedStatuses.removeAll()
        applyFilters()
    }
    
    func filterByType(_ type: AccessoryType) {
        selectedTypes = [type]
        selectedStatuses.removeAll()
        searchText = ""
        applyFilters()
    }
        
    func getCategoryCounts() -> [(type: AccessoryType, count: Int)] {
        let counts = AccessoryType.allCases.map { type in
            (type: type, count: accessories.filter { $0.type == type }.count)
        }.filter { $0.count > 0 }
        
        return counts
    }
    
    func getAccessory(by id: UUID) -> Accessory? {
        return accessories.first { $0.id == id }
    }
        
    private func saveAccessories() {
        if let encoded = try? JSONEncoder().encode(accessories) {
            userDefaults.set(encoded, forKey: accessoriesKey)
        }
    }
    
    private func loadAccessories() {
        if let data = userDefaults.data(forKey: accessoriesKey),
           let decoded = try? JSONDecoder().decode([Accessory].self, from: data) {
            accessories = decoded
        }
    }
}
