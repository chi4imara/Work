import Foundation
import SwiftUI
import Combine

class PurchaseStore: ObservableObject {
    @Published var purchases: [Purchase] = []
    @Published var filterSettings = FilterSettings()
    
    private let userDefaults = UserDefaults.standard
    private let purchasesKey = "SavedPurchases"
    
    init() {
        loadPurchases()
        
        filterSettings.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    private func addSampleData() {
        let samplePurchases = [
            Purchase(name: "Sofa", category: .furniture, purchaseDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(), serviceLifeYears: 10, comment: "Comfortable living room sofa", isFavorite: true),
            Purchase(name: "Refrigerator", category: .appliances, purchaseDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(), serviceLifeYears: 15, comment: "Energy efficient model"),
            Purchase(name: "iPhone", category: .electronics, purchaseDate: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), serviceLifeYears: 3, comment: "Latest model", isFavorite: true),
            Purchase(name: "Dining Table", category: .furniture, purchaseDate: Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date(), serviceLifeYears: 8, comment: "Wooden table for 6 people"),
            Purchase(name: "Washing Machine", category: .appliances, purchaseDate: Calendar.current.date(byAdding: .month, value: -18, to: Date()) ?? Date(), serviceLifeYears: 12, comment: "Front loading machine"),
            Purchase(name: "Laptop", category: .electronics, purchaseDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(), serviceLifeYears: 5, comment: "Work laptop"),
            Purchase(name: "Bookshelf", category: .furniture, purchaseDate: Calendar.current.date(byAdding: .month, value: -9, to: Date()) ?? Date(), serviceLifeYears: 6, comment: "Tall wooden bookshelf"),
            Purchase(name: "Coffee Maker", category: .appliances, purchaseDate: Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date(), serviceLifeYears: 4, comment: "Programmable coffee maker")
        ]
        
        for purchase in samplePurchases {
            purchases.append(purchase)
        }
        savePurchases()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredPurchases: [Purchase] {
        filterSettings.applyFilters(to: purchases)
    }
    
    var favoritePurchases: [Purchase] {
        purchases.filter { $0.isFavorite }
            .sorted { $0.dateUpdated > $1.dateUpdated }
    }
    
    func addPurchase(_ purchase: Purchase) {
        purchases.append(purchase)
        savePurchases()
    }
    
    func updatePurchase(_ purchase: Purchase) {
        if let index = purchases.firstIndex(where: { $0.id == purchase.id }) {
            var updatedPurchase = purchase
            updatedPurchase.dateUpdated = Date()
            purchases[index] = updatedPurchase
            savePurchases()
        }
    }
    
    func deletePurchase(_ purchase: Purchase) {
        purchases.removeAll { $0.id == purchase.id }
        savePurchases()
    }
    
    func toggleFavorite(_ purchase: Purchase) {
        if let index = purchases.firstIndex(where: { $0.id == purchase.id }) {
            purchases[index].isFavorite.toggle()
            purchases[index].dateUpdated = Date()
            savePurchases()
        }
    }

    var totalPurchases: Int {
        purchases.count
    }
    
    var purchasesByCategory: [PurchaseCategory: Int] {
        Dictionary(grouping: purchases, by: { $0.category })
            .mapValues { $0.count }
    }
    
    var purchasesByStatus: [PurchaseStatus: Int] {
        Dictionary(grouping: purchases, by: { $0.status })
            .mapValues { $0.count }
    }
    
    var favoriteCount: Int {
        purchases.filter { $0.isFavorite }.count
    }
    
    var purchasesByServiceLife: [String: Int] {
        let groups = Dictionary(grouping: purchases) { purchase in
            switch purchase.serviceLifeYears {
            case 1...3:
                return "1-3 years"
            case 4...6:
                return "4-6 years"
            default:
                return "7+ years"
            }
        }
        return groups.mapValues { $0.count }
    }
    
    private func savePurchases() {
        if let encoded = try? JSONEncoder().encode(purchases) {
            userDefaults.set(encoded, forKey: purchasesKey)
        }
    }
    
    private func loadPurchases() {
        if let data = userDefaults.data(forKey: purchasesKey),
           let decoded = try? JSONDecoder().decode([Purchase].self, from: data) {
            purchases = decoded
        }
    }
}
