import Foundation
import Combine

class BrandStore: ObservableObject {
    @Published var brands: [Brand] = []
    @Published var searchText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let brandsKey = "SavedBrands"
    
    init() {
        loadBrands()
    }
    
    var filteredBrands: [Brand] {
        if searchText.isEmpty {
            return brands.sorted { $0.dateAdded > $1.dateAdded }
        } else {
            return brands.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                .sorted { $0.dateAdded > $1.dateAdded }
        }
    }
    
    var categoriesWithCounts: [(category: BrandCategory, count: Int)] {
        let groupedBrands = Dictionary(grouping: brands) { $0.category }
        return BrandCategory.allCases.compactMap { category in
            if let brandsInCategory = groupedBrands[category], !brandsInCategory.isEmpty {
                return (category: category, count: brandsInCategory.count)
            }
            return nil
        }.sorted { $0.category.displayName < $1.category.displayName }
    }
    
    func brands(for category: BrandCategory) -> [Brand] {
        return brands.filter { $0.category == category }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func getBrand(by id: UUID) -> Brand? {
        return brands.first { $0.id == id }
    }
    
    func addBrand(_ brand: Brand) {
        brands.append(brand)
        saveBrands()
    }
    
    func updateBrand(_ brand: Brand) {
        if let index = brands.firstIndex(where: { $0.id == brand.id }) {
            brands[index] = brand
            saveBrands()
        }
    }
    
    func deleteBrand(_ brand: Brand) {
        brands.removeAll { $0.id == brand.id }
        saveBrands()
    }
    
    func deleteBrand(by id: UUID) {
        brands.removeAll { $0.id == id }
        saveBrands()
    }
    
    private func saveBrands() {
        if let encoded = try? JSONEncoder().encode(brands) {
            userDefaults.set(encoded, forKey: brandsKey)
        }
    }
    
    private func loadBrands() {
        if let data = userDefaults.data(forKey: brandsKey),
           let decoded = try? JSONDecoder().decode([Brand].self, from: data) {
            brands = decoded
        }
    }
}
