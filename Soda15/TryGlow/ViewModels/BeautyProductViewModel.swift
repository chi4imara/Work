import Foundation
import SwiftUI
import Combine

class BeautyProductViewModel: ObservableObject {
    @Published var products: [BeautyProduct] = []
    @Published var selectedCategory: ProductCategory? = nil
    @Published var showOnboarding = true
    @Published var isLoading = true
    
    private let userDefaults = UserDefaults.standard
    private let productsKey = "SavedBeautyProducts"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadProducts()
        checkOnboardingStatus()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
        }
    }
    
    func addProduct(_ product: BeautyProduct) {
        products.append(product)
        saveProducts()
    }
    
    func updateProduct(_ product: BeautyProduct) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveProducts()
        }
    }
    
    func deleteProduct(_ product: BeautyProduct) {
        products.removeAll { $0.id == product.id }
        saveProducts()
    }
    
    func filteredProducts() -> [BeautyProduct] {
        if let category = selectedCategory {
            return products.filter { $0.category == category }
        }
        return products
    }
    
    func productsByCategory(_ category: ProductCategory) -> [BeautyProduct] {
        return products.filter { $0.category == category }
    }
    
    func allComments() -> [(product: BeautyProduct, comment: String)] {
        return products.compactMap { product in
            guard !product.comment.isEmpty else { return nil }
            return (product: product, comment: product.comment)
        }
    }
    
    func commentsByCategory(_ category: ProductCategory?) -> [(product: BeautyProduct, comment: String)] {
        let comments = allComments()
        if let category = category {
            return comments.filter { $0.product.category == category }
        }
        return comments
    }
    
    func clearAllComments() {
        for i in products.indices {
            products[i].comment = ""
        }
        saveProducts()
    }
    
    func completeOnboarding() {
        showOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            userDefaults.set(encoded, forKey: productsKey)
        }
    }
    
    private func loadProducts() {
        if let data = userDefaults.data(forKey: productsKey),
           let decoded = try? JSONDecoder().decode([BeautyProduct].self, from: data) {
            products = decoded
        }
    }
    
    private func checkOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
}
