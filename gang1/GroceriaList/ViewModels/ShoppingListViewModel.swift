import Foundation
import SwiftUI
import Combine

class ShoppingListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var searchText: String = ""
    @Published var showingAddProduct = false
    @Published var showingCategories = false
    @Published var showingTips = false
    @Published var editingProduct: Product?
    
    private let productsKey = "SavedProducts"
    private let categoriesKey = "SavedCategories"
    
    init() {
        loadData()
    }
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products.sorted { !$0.isCompleted && $1.isCompleted }
        } else {
            return products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.category.localizedCaseInsensitiveContains(searchText)
            }.sorted { !$0.isCompleted && $1.isCompleted }
        }
    }
    
    var completedProductsCount: Int {
        products.filter { $0.isCompleted }.count
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
    
    func toggleProductCompletion(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isCompleted.toggle()
            saveProducts()
        }
    }
    
    func deleteCompletedProducts() {
        products.removeAll { $0.isCompleted }
        saveProducts()
    }
    
    func clearAllProducts() {
        products.removeAll()
        saveProducts()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            saveCategories()
        }
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        saveCategories()
    }
    
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: productsKey)
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: productsKey),
           let decodedProducts = try? JSONDecoder().decode([Product].self, from: data) {
            products = decodedProducts
        }
        
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decodedCategories
        }
    }
}
