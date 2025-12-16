import Foundation
import SwiftUI
import Combine

class CosmeticBagViewModel: ObservableObject {
    @Published var cosmeticBags: [CosmeticBag] = []
    @Published var selectedBag: CosmeticBag?
    
    private let userDefaults = UserDefaults.standard
    private let cosmeticBagsKey = "cosmeticBags"
    
    init() {
        loadCosmeticBags()
    }
        
    func addCosmeticBag(_ bag: CosmeticBag) {
        var newBag = bag
        if newBag.isActive {
            for index in cosmeticBags.indices {
                cosmeticBags[index].isActive = false
            }
        }
        cosmeticBags.append(newBag)
        saveCosmeticBags()
    }
    
    func updateCosmeticBag(_ bag: CosmeticBag) {
        if let index = cosmeticBags.firstIndex(where: { $0.id == bag.id }) {
            var updatedBag = bag
            if updatedBag.isActive {
                for bagIndex in cosmeticBags.indices {
                    if bagIndex != index {
                        cosmeticBags[bagIndex].isActive = false
                    }
                }
            }
            cosmeticBags[index] = updatedBag
            saveCosmeticBags()
        }
    }
    
    func deleteCosmeticBag(_ bag: CosmeticBag) {
        cosmeticBags.removeAll { $0.id == bag.id }
        saveCosmeticBags()
    }
    
    func getCosmeticBag(by id: UUID) -> CosmeticBag? {
        return cosmeticBags.first { $0.id == id }
    }
        
    func addProduct(_ product: Product, to bagId: UUID) {
        if let index = cosmeticBags.firstIndex(where: { $0.id == bagId }) {
            cosmeticBags[index].products.append(product)
            saveCosmeticBags()
        }
    }
    
    func updateProduct(_ product: Product) {
        for bagIndex in cosmeticBags.indices {
            if let productIndex = cosmeticBags[bagIndex].products.firstIndex(where: { $0.id == product.id }) {
                cosmeticBags[bagIndex].products[productIndex] = product
                saveCosmeticBags()
                return
            }
        }
    }
    
    func deleteProduct(_ product: Product) {
        for bagIndex in cosmeticBags.indices {
            cosmeticBags[bagIndex].products.removeAll { $0.id == product.id }
        }
        saveCosmeticBags()
    }
    
    func getProduct(by id: UUID) -> Product? {
        for bag in cosmeticBags {
            if let product = bag.products.first(where: { $0.id == id }) {
                return product
            }
        }
        return nil
    }
    
    func getAllProducts() -> [Product] {
        return cosmeticBags.flatMap { $0.products }
    }
    
    func getFilteredProducts(status: ProductStatus? = nil, searchText: String = "") -> [Product] {
        var products = getAllProducts()
        
        if let status = status {
            products = products.filter { $0.status == status }
        }
        
        if !searchText.isEmpty {
            products = products.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return products
    }
        
    private func saveCosmeticBags() {
        if let encoded = try? JSONEncoder().encode(cosmeticBags) {
            userDefaults.set(encoded, forKey: cosmeticBagsKey)
        }
    }
    
    private func loadCosmeticBags() {
        if let data = userDefaults.data(forKey: cosmeticBagsKey),
           let decoded = try? JSONDecoder().decode([CosmeticBag].self, from: data) {
            cosmeticBags = decoded
        }
    }
}
