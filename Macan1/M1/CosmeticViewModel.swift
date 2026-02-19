import Foundation
import SwiftUI
import Combine

class CosmeticViewModel: ObservableObject {
    @Published var products: [CosmeticProduct] = []
    @Published var searchText: String = ""
    @Published var filterOptions = FilterOptions()
    @Published var sortOption: SortOption = .name
    @Published var isAscending: Bool = true
    
    var filteredProducts: [CosmeticProduct] {
        var filtered = products
        
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !filterOptions.selectedBrands.isEmpty {
            filtered = filtered.filter { filterOptions.selectedBrands.contains($0.brand) }
        }
        
        if !filterOptions.selectedTypes.isEmpty {
            filtered = filtered.filter { filterOptions.selectedTypes.contains($0.type) }
        }
        
        if !filterOptions.selectedStatuses.isEmpty {
            filtered = filtered.filter { filterOptions.selectedStatuses.contains($0.expirationStatus) }
        }
        
        filtered = filtered.filter { product in
            product.rating >= filterOptions.minRating && product.rating <= filterOptions.maxRating
        }
        
        filtered.sort { first, second in
            let result: Bool
            switch sortOption {
            case .name:
                result = first.name < second.name
            case .brand:
                result = first.brand < second.brand
            case .expirationDate:
                result = first.expirationDate < second.expirationDate
            case .rating:
                result = first.rating < second.rating
            case .purchaseDate:
                result = first.purchaseDate < second.purchaseDate
            }
            return isAscending ? result : !result
        }
        
        return filtered
    }
    
    var favoriteProducts: [CosmeticProduct] {
        filteredProducts.filter { $0.isFavorite }
    }
    
    var availableBrands: [String] {
        Array(Set(products.map { $0.brand })).sorted()
    }
    
    var expiringProducts: [CosmeticProduct] {
        products.filter { $0.expirationStatus == .expiringSoon || $0.expirationStatus == .expired }
    }
    
    init() {
        loadProducts()
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
    
    func toggleFavorite(_ product: CosmeticProduct) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isFavorite.toggle()
            saveProducts()
        }
    }
    
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: "CosmeticProducts")
        }
    }
    
    private func loadProducts() {
        if let data = UserDefaults.standard.data(forKey: "CosmeticProducts"),
           let decoded = try? JSONDecoder().decode([CosmeticProduct].self, from: data) {
            products = decoded
        }
    }
}
