import Foundation
import SwiftUI
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText = ""
    
    private let userDefaults = UserDefaults.standard
    private let productsKey = "SavedProducts"
    
    init() {
        loadProducts()
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
    
    func toggleFavorite(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isFavorite.toggle()
            saveProducts()
        }
    }
        
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var favoriteProducts: [Product] {
        return products.filter { $0.isFavorite }
    }
    
    func products(for category: ProductCategory) -> [Product] {
        return products.filter { $0.category == category }
    }
    
    func product(withId id: UUID) -> Product? {
        return products.first { $0.id == id }
    }
        
    var categoriesInfo: [CategoryInfo] {
        let categories = ProductCategory.allCases
        return categories.compactMap { category in
            let count = products(for: category).count
            return count > 0 ? CategoryInfo(category: category, productCount: count) : nil
        }
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
}
