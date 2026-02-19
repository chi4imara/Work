import Foundation
import SwiftUI
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All Categories"
    @Published var sortOption: SortOption = .dateAdded
    
    enum SortOption: String, CaseIterable {
        case dateAdded = "Date Added"
        case name = "Name"
        case rating = "Rating"
        case expirationDate = "Expiration Date"
        case category = "Category"
    }
    
    private let userDefaults = UserDefaults.standard
    private let productsKey = AppConstants.UserDefaultsKeys.savedProducts
    
    init() {
        loadProducts()
    }
    
    var filteredProducts: [Product] {
        var filtered = products
        
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if selectedCategory != "All Categories" {
            filtered = filtered.filter { product in
                product.category == selectedCategory
            }
        }
        
        return sortProducts(filtered)
    }
    
    var categories: [Category] {
        let categoryNames = Set(products.map { $0.category })
        return categoryNames.map { categoryName in
            let count = products.filter { $0.category == categoryName }.count
            return Category(name: categoryName, productCount: count)
        }.sorted { $0.name < $1.name }
    }
    
    var categoryNames: [String] {
        var names = ["All Categories"]
        names.append(contentsOf: categories.map { $0.name })
        return names
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        saveProducts()
    }
    
    func updateProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveProducts()
        }
    }
    
    func deleteProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
        saveProducts()
    }
    
    func getProductsForCategory(_ categoryName: String) -> [Product] {
        return products.filter { $0.category == categoryName }
            .sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func getProduct(by id: UUID) -> Product? {
        return products.first { $0.id == id }
    }
    
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            userDefaults.set(encoded, forKey: productsKey)
        }
    }
    
    private func loadProducts() {
        if let data = userDefaults.data(forKey: productsKey),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            products = decoded
        }
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func resetCategoryFilter() {
        selectedCategory = "All Categories"
    }
    
    private func sortProducts(_ products: [Product]) -> [Product] {
        switch sortOption {
        case .dateAdded:
            return products.sorted { $0.dateAdded > $1.dateAdded }
        case .name:
            return products.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .rating:
            return products.sorted { $0.rating > $1.rating }
        case .expirationDate:
            return products.sorted { $0.expirationDate < $1.expirationDate }
        case .category:
            return products.sorted { $0.category.localizedCaseInsensitiveCompare($1.category) == .orderedAscending }
        }
    }
}
