import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var storageLocations: [StorageLocation] = []
    @Published var showOnboarding = true
    @Published var isLoading = true
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "hasSeenOnboarding"
    
    init() {
        loadData()
        checkOnboardingStatus()
    }
    
    func checkOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: onboardingKey)
        showOnboarding = false
    }
    
    func finishLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
        }
    }
    
    func addStorageLocation(_ location: StorageLocation) {
        storageLocations.append(location)
        saveData()
    }
    
    func updateStorageLocation(_ location: StorageLocation) {
        if let index = storageLocations.firstIndex(where: { $0.id == location.id }) {
            storageLocations[index] = location
            saveData()
        }
    }
    
    func deleteStorageLocation(_ location: StorageLocation) {
        storageLocations.removeAll { $0.id == location.id }
        saveData()
    }
    
    func addProduct(_ product: Product, to locationId: UUID) {
        if let index = storageLocations.firstIndex(where: { $0.id == locationId }) {
            storageLocations[index].products.append(product)
            saveData()
        }
    }
    
    func updateProduct(_ product: Product) {
        for (locationIndex, location) in storageLocations.enumerated() {
            if let productIndex = location.products.firstIndex(where: { $0.id == product.id }) {
                storageLocations[locationIndex].products[productIndex] = product
                saveData()
                return
            }
        }
    }
    
    func deleteProduct(_ product: Product) {
        for (locationIndex, location) in storageLocations.enumerated() {
            if let productIndex = location.products.firstIndex(where: { $0.id == product.id }) {
                storageLocations[locationIndex].products.remove(at: productIndex)
                saveData()
                return
            }
        }
    }
    
    func moveProduct(_ product: Product, to newLocationId: UUID) {
        deleteProduct(product)
        
        var updatedProduct = product
        updatedProduct.storageLocationId = newLocationId
        addProduct(updatedProduct, to: newLocationId)
    }
    
    var allProducts: [Product] {
        storageLocations.flatMap { $0.products }
    }
    
    func getStorageLocation(for productId: UUID) -> StorageLocation? {
        return storageLocations.first { location in
            location.products.contains { $0.id == productId }
        }
    }
    
    func markProductAsUsed(_ product: Product) {
        for (locationIndex, location) in storageLocations.enumerated() {
            if let productIndex = location.products.firstIndex(where: { $0.id == product.id }) {
                storageLocations[locationIndex].products[productIndex].lastUsedDate = Date()
                storageLocations[locationIndex].products[productIndex].usageCount += 1
                saveData()
                return
            }
        }
    }
    
    var brandStatistics: [BrandStat] {
        let brandGroups = Dictionary(grouping: allProducts) { $0.brand }
        return brandGroups.map { brand, products in
            BrandStat(brand: brand, count: products.count, products: products)
        }
        .sorted { $0.count > $1.count }
    }
    
    var recentlyAddedProducts: [Product] {
        allProducts
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(10)
            .map { $0 }
    }
    
    func exportData() -> String? {
        guard let encoded = try? JSONEncoder().encode(storageLocations),
              let jsonString = String(data: encoded, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(storageLocations) {
            userDefaults.set(encoded, forKey: "storageLocations")
        }
    }
    
    private func loadData() {
        if let data = userDefaults.data(forKey: "storageLocations"),
           let decoded = try? JSONDecoder().decode([StorageLocation].self, from: data) {
            storageLocations = decoded
        }
    }
}

class StorageLocationViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var selectedIcon = StorageIcon.box.rawValue
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func createStorageLocation() -> StorageLocation {
        return StorageLocation(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            icon: selectedIcon
        )
    }
    
    func reset() {
        name = ""
        description = ""
        selectedIcon = StorageIcon.box.rawValue
    }
    
    func populate(from location: StorageLocation) {
        name = location.name
        description = location.description
        selectedIcon = location.icon
    }
}

class ProductViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedCategory = ProductCategory.other
    @Published var brand = ""
    @Published var storageLocationId: UUID?
    @Published var expirationDate: Date?
    @Published var hasExpirationDate = false
    @Published var notes = ""
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        storageLocationId != nil
    }
    
    func createProduct() -> Product? {
        guard let locationId = storageLocationId else { return nil }
        
        return Product(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory,
            brand: brand.trimmingCharacters(in: .whitespacesAndNewlines),
            storageLocationId: locationId,
            expirationDate: hasExpirationDate ? expirationDate : nil,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func reset() {
        name = ""
        selectedCategory = .other
        brand = ""
        storageLocationId = nil
        expirationDate = nil
        hasExpirationDate = false
        notes = ""
    }
    
    func populate(from product: Product) {
        name = product.name
        selectedCategory = product.category
        brand = product.brand
        storageLocationId = product.storageLocationId
        expirationDate = product.expirationDate
        hasExpirationDate = product.expirationDate != nil
        notes = product.notes
    }
}

class ProductsListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedFilter = ProductFilter.all
    @Published var selectedCategory: ProductCategory?
    
    func filteredProducts(from products: [Product]) -> [Product] {
        var filtered = products
        
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText) ||
                product.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        switch selectedFilter {
        case .all:
            return filtered.sorted { $0.name < $1.name }
        case .category:
            return filtered.sorted { $0.category.displayName < $1.category.displayName }
        case .expiration:
            return filtered.sorted { product1, product2 in
                guard let date1 = product1.expirationDate else { return false }
                guard let date2 = product2.expirationDate else { return true }
                return date1 < date2
            }
        case .brand:
            return filtered.sorted { $0.brand < $1.brand }
        }
    }
    
    func reset() {
        searchText = ""
        selectedFilter = .all
        selectedCategory = nil
    }
}

struct BrandStat {
    let brand: String
    let count: Int
    let products: [Product]
}
