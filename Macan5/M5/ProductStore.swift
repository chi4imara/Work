import Foundation
import Combine

class ProductStore: ObservableObject {
    @Published var products: [Product] = []
    @Published var filterOptions = FilterOptions()
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
    
    func updateProductStatus(_ product: Product, newStatus: ProductStatus) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].updateStatus(newStatus)
            saveProducts()
        }
    }
    
    var filteredProducts: [Product] {
        var filtered = products
        
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.brand.localizedCaseInsensitiveContains(searchText) ||
                product.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !filterOptions.selectedStatuses.isEmpty {
            filtered = filtered.filter { filterOptions.selectedStatuses.contains($0.status) }
        }
        
        if !filterOptions.selectedCategories.isEmpty {
            filtered = filtered.filter { filterOptions.selectedCategories.contains($0.category) }
        }
        
        if !filterOptions.brandFilter.isEmpty {
            filtered = filtered.filter { $0.brand.localizedCaseInsensitiveContains(filterOptions.brandFilter) }
        }
        
        return filtered.sorted { $0.dateModified > $1.dateModified }
    }
    
    var categorySummaries: [CategorySummary] {
        let groupedProducts = Dictionary(grouping: products) { $0.category }
        
        return ProductCategory.allCases.compactMap { category in
            let categoryProducts = groupedProducts[category] ?? []
            guard !categoryProducts.isEmpty else { return nil }
            
            return CategorySummary(
                category: category,
                count: categoryProducts.count,
                products: categoryProducts.sorted { $0.dateModified > $1.dateModified }
            )
        }.sorted { $0.count > $1.count }
    }
    
    func productsForCategory(_ category: ProductCategory) -> [Product] {
        return products.filter { $0.category == category }
            .sorted { $0.dateModified > $1.dateModified }
    }
    
    var shoppingListProducts: [Product] {
        return products.filter { $0.status == .needToBuy }
            .sorted { $0.dateModified > $1.dateModified }
    }
    
    func markAsPurchased(_ product: Product) {
        updateProductStatus(product, newStatus: .inStock)
    }
    
    func clearPurchasedItems() {
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
