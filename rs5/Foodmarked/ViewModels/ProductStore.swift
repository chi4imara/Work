import Foundation
import SwiftUI
import Combine

class ProductStore: ObservableObject {
    @Published var products: [Product] = []
    
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
    
    func clearAllProducts() {
        products.removeAll()
        saveProducts()
    }
    
    func toggleProductStatus(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            let newStatus: ProductStatus = products[index].status == .suitable ? .unsuitable : .suitable
            products[index].changeStatus(newStatus)
            saveProducts()
        }
    }
    
    func toggleFavorite(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].toggleFavorite()
            saveProducts()
        }
    }
    
    var suitableProducts: [Product] {
        products.filter { $0.status == .suitable }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var unsuitableProducts: [Product] {
        products.filter { $0.status == .unsuitable }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var favoriteProducts: [Product] {
        products.filter { $0.isFavorite }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var productsByCategory: [ProductCategory: [Product]] {
        Dictionary(grouping: products, by: { $0.category })
    }
    
    func exportProducts() -> String {
        var exportText = "My Product List\n"
        exportText += "Generated: \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short))\n\n"
        
        exportText += "=== SUITABLE PRODUCTS ===\n"
        for product in suitableProducts {
            exportText += "✓ \(product.name) (\(product.category.rawValue))\n"
        }
        
        exportText += "\n=== NOT SUITABLE PRODUCTS ===\n"
        for product in unsuitableProducts {
            exportText += "✗ \(product.name) (\(product.category.rawValue))\n"
        }
        
        exportText += "\n=== STATISTICS ===\n"
        exportText += "Total: \(products.count)\n"
        exportText += "Suitable: \(suitableProducts.count)\n"
        exportText += "Not Suitable: \(unsuitableProducts.count)\n"
        exportText += "Favorites: \(favoriteProducts.count)\n"
        
        return exportText
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
