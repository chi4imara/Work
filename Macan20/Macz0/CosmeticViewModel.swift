import Foundation
import SwiftUI
import Combine

class CosmeticViewModel: ObservableObject {
    @Published var products: [CosmeticProduct] = []
    @Published var searchText: String = ""
    @Published var currentFilter = FilterOptions()
    @Published var showingOnboarding = true
    @Published var showingSplash = true
    @Published var isLoadingTabBar = false
    
    private let userDefaults = UserDefaults.standard
    private let productsKey = "SavedProducts"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadProducts()
        checkOnboardingStatus()
    }
        
    func addProduct(_ product: CosmeticProduct) {
        products.append(product)
        saveProducts()
    }
    
    func updateProduct(_ product: CosmeticProduct) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveProducts()
        }
    }
    
    func deleteProduct(_ product: CosmeticProduct) {
        products.removeAll { $0.id == product.id }
        saveProducts()
    }
        
    var filteredProducts: [CosmeticProduct] {
        return products.filter { product in
            product.matches(filter: currentFilter, searchText: searchText)
        }
    }
    
    func applyFilter(_ filter: FilterOptions) {
        currentFilter = filter
    }
    
    func resetFilter() {
        currentFilter.reset()
    }
    
    func filterByType(_ type: ProductType) {
        currentFilter.reset()
        currentFilter.selectedTypes.insert(type)
    }
        
    func getProductCount(for type: ProductType) -> Int {
        return products.filter { $0.type == type }.count
    }
    
    var categoryCounts: [(ProductType, Int)] {
        return ProductType.allCases.map { type in
            (type, getProductCount(for: type))
        }.filter { $0.1 > 0 }
    }
        
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            userDefaults.set(encoded, forKey: productsKey)
        }
    }
    
    private func loadProducts() {
        if let data = userDefaults.data(forKey: productsKey),
           let decoded = try? JSONDecoder().decode([CosmeticProduct].self, from: data) {
            products = decoded
        }
    }
        
    private func checkOnboardingStatus() {
        showingOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: onboardingKey)
        showingOnboarding = false
    }
    
    func completeSplash() {
        showingSplash = false
        isLoadingTabBar = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isLoadingTabBar = false
        }
    }
}
