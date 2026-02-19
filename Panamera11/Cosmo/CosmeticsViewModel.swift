import Foundation
import SwiftUI
import Combine

class CosmeticsViewModel: ObservableObject {
    @Published var products: [CosmeticProduct] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: Category?
    @Published var isLoading: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let productsKey = "SavedCosmeticProducts"
    
    init() {
        loadProducts()
    }
    
    var filteredProducts: [CosmeticProduct] {
        var filtered = products
        
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.shade.localizedCaseInsensitiveContains(searchText) ||
                product.suitableFor.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            switch category.type {
            case .productType(let type):
                filtered = filtered.filter { $0.productType == type }
            case .texture(let texture):
                filtered = filtered.filter { $0.texture == texture }
            }
        }
        
        return filtered.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var favoriteProducts: [CosmeticProduct] {
        return products.filter { $0.isFavorite }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var categories: [Category] {
        var categoryList: [Category] = []
        
        for productType in ProductType.allCases {
            let count = products.filter { $0.productType == productType }.count
            if count > 0 {
                categoryList.append(Category(name: productType.displayName, count: count, type: .productType(productType)))
            }
        }
        
        for texture in Texture.allCases {
            let count = products.filter { $0.texture == texture }.count
            if count > 0 {
                categoryList.append(Category(name: texture.displayName, count: count, type: .texture(texture)))
            }
        }
        
        return categoryList.sorted { $0.count > $1.count }
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
    
    func toggleFavorite(for product: CosmeticProduct) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isFavorite.toggle()
            saveProducts()
        }
    }
    
    func selectCategory(_ category: Category?) {
        selectedCategory = category
    }
    
    func clearCategoryFilter() {
        selectedCategory = nil
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    private func saveProducts() {
        do {
            let data = try JSONEncoder().encode(products)
            userDefaults.set(data, forKey: productsKey)
        } catch {
            print("Failed to save products: \(error)")
        }
    }
    
    private func loadProducts() {
        guard let data = userDefaults.data(forKey: productsKey) else { return }
        
        do {
            products = try JSONDecoder().decode([CosmeticProduct].self, from: data)
        } catch {
            print("Failed to load products: \(error)")
            products = []
        }
    }
    
    func addSampleData() {
        let sampleProducts = [
            CosmeticProduct(
                name: "Fenty Beauty Foundation",
                shade: "240 Medium",
                texture: .liquid,
                productType: .foundation,
                suitableFor: "Daily wear, office",
                notes: "Great coverage, long-lasting"
            ),
            CosmeticProduct(
                name: "Charlotte Tilbury Lipstick",
                shade: "Pillow Talk",
                texture: .matte,
                productType: .lipstick,
                suitableFor: "Everyday, romantic dates",
                notes: "Perfect nude shade"
            ),
            CosmeticProduct(
                name: "Rare Beauty Blush",
                shade: "Joy",
                texture: .liquid,
                productType: .blush,
                suitableFor: "Natural look, daytime",
                notes: "Highly pigmented, blend well"
            )
        ]
        
        for product in sampleProducts {
            if !products.contains(where: { $0.name == product.name }) {
                addProduct(product)
            }
        }
    }
}
