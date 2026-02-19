import Foundation
import SwiftUI
import Combine

struct Category: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    
    static let defaultCategories = [
        "Earrings",
        "Rings", 
        "Bracelets",
        "Necklaces",
        "Watches"
    ]
}

struct Outfit: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var createdAt: Date
    
    init(name: String, description: String = "") {
        self.id = UUID()
        self.name = name
        self.description = description
        self.createdAt = Date()
    }
}

struct Accessory: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var category: String
    var description: String
    var outfitIds: Set<UUID>
    var createdAt: Date
    
    init(name: String, category: String, description: String = "", outfitIds: Set<UUID> = []) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.description = description
        self.outfitIds = outfitIds
        self.createdAt = Date()
    }
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var accessories: [Accessory] = []
    @Published var outfits: [Outfit] = []
    @Published var categories: [Category] = []
    
    private let accessoriesKey = "SavedAccessories"
    private let outfitsKey = "SavedOutfits"
    private let categoriesKey = "SavedCategories"
    
    private init() {
        loadData()
        setupDefaultCategories()
    }
    
    private func saveData() {
        if let accessoriesData = try? JSONEncoder().encode(accessories) {
            UserDefaults.standard.set(accessoriesData, forKey: accessoriesKey)
        }
        
        if let outfitsData = try? JSONEncoder().encode(outfits) {
            UserDefaults.standard.set(outfitsData, forKey: outfitsKey)
        }
        
        if let categoriesData = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(categoriesData, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        if let accessoriesData = UserDefaults.standard.data(forKey: accessoriesKey),
           let decodedAccessories = try? JSONDecoder().decode([Accessory].self, from: accessoriesData) {
            accessories = decodedAccessories
        }
        
        if let outfitsData = UserDefaults.standard.data(forKey: outfitsKey),
           let decodedOutfits = try? JSONDecoder().decode([Outfit].self, from: outfitsData) {
            outfits = decodedOutfits
        }
        
        if let categoriesData = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        }
    }
    
    private func setupDefaultCategories() {
        if categories.isEmpty {
            categories = Category.defaultCategories.map { Category(name: $0) }
            saveData()
        }
    }
    
    func addAccessory(_ accessory: Accessory) {
        accessories.append(accessory)
        saveData()
    }
    
    func updateAccessory(_ accessory: Accessory) {
        if let index = accessories.firstIndex(where: { $0.id == accessory.id }) {
            accessories[index] = accessory
            saveData()
        }
    }
    
    func deleteAccessory(_ accessory: Accessory) {
        accessories.removeAll { $0.id == accessory.id }
        saveData()
    }
    
    func getAccessoriesForOutfit(_ outfitId: UUID) -> [Accessory] {
        return accessories.filter { $0.outfitIds.contains(outfitId) }
    }
    
    func addOutfit(_ outfit: Outfit) {
        outfits.append(outfit)
        saveData()
    }
    
    func updateOutfit(_ outfit: Outfit) {
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
            saveData()
        }
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        for i in accessories.indices {
            accessories[i].outfitIds.remove(outfit.id)
        }
        
        outfits.removeAll { $0.id == outfit.id }
        saveData()
    }
    
    func addCategory(_ categoryName: String) {
        let category = Category(name: categoryName)
        categories.append(category)
        saveData()
    }
    
    func getCategoriesWithCounts() -> [(category: String, count: Int)] {
        let allCategories = Set(accessories.map { $0.category })
        return allCategories.map { category in
            let count = accessories.filter { $0.category == category }.count
            return (category: category, count: count)
        }.sorted { $0.category < $1.category }
    }
    
    func filteredAccessories(searchText: String, selectedCategory: String) -> [Accessory] {
        var filtered = accessories
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if selectedCategory != "All Categories" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        return filtered.sorted { $0.createdAt > $1.createdAt }
    }
}
