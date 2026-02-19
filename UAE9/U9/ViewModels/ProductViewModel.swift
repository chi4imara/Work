import Foundation
import SwiftUI
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var showingOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    private let productsKey = "SavedProducts"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadProducts()
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        showingOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: onboardingKey)
        showingOnboarding = false
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
    
    func markProductAsUsed(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].markAsUsed()
            saveProducts()
        }
    }
    
    func updateProductStatus(_ product: Product, status: ProductStatus, stockLevel: StockLevel) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].updateStatus(status, stockLevel: stockLevel)
            saveProducts()
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
        } else {
            products = []
        }
    }
    
    var recentlyUpdatedProduct: Product? {
        products.max(by: { $0.updatedAt < $1.updatedAt })
    }
    
    var productsByCategory: [ProductCategory: [Product]] {
        Dictionary(grouping: products) { $0.category }
    }
    
    var productsByStockLevel: [StockLevel: [Product]] {
        Dictionary(grouping: products) { $0.stockLevel }
    }
    
    var lowStockProducts: [Product] {
        products.filter { $0.stockLevel == .low }
    }
    
    var runningOutProducts: [Product] {
        products.filter { $0.status == .runningOut }
    }
    
    func products(for category: ProductCategory) -> [Product] {
        products.filter { $0.category == category }
    }
    
    func products(for stockLevel: StockLevel) -> [Product] {
        products.filter { $0.stockLevel == stockLevel }
    }
    
    func categoryStats(for category: ProductCategory) -> (total: Int, inUse: Int, runningOut: Int) {
        let categoryProducts = products(for: category)
        let inUse = categoryProducts.filter { $0.status == .inUse }.count
        let runningOut = categoryProducts.filter { $0.status == .runningOut }.count
        return (categoryProducts.count, inUse, runningOut)
    }
    
    func searchProducts(query: String) -> [Product] {
        if query.isEmpty {
            return products
        }
        return products.filter { 
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.category.displayName.localizedCaseInsensitiveContains(query) ||
            $0.notes.localizedCaseInsensitiveContains(query)
        }
    }
}
