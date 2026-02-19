import Foundation
import Combine
import SwiftUI

class PurchaseViewModel: ObservableObject {
    @Published var purchases: [Purchase] = []
    @Published var searchText: String = ""
    @Published var filteredPurchases: [Purchase] = []
    
    private let userDefaultsKey = Constants.UserDefaults.savedPurchases
    
    init() {
        loadPurchases()
        setupSearchBinding()
    }
    
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterPurchases(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func addPurchase(_ purchase: Purchase) {
        purchases.append(purchase)
        savePurchases()
        filterPurchases(with: searchText)
    }
    
    func updatePurchase(_ purchase: Purchase) {
        if let index = purchases.firstIndex(where: { $0.id == purchase.id }) {
            purchases[index] = purchase
            savePurchases()
            filterPurchases(with: searchText)
        }
    }
    
    func deletePurchase(_ purchase: Purchase) {
        purchases.removeAll { $0.id == purchase.id }
        savePurchases()
        filterPurchases(with: searchText)
    }
    
    func deletePurchase(at indexSet: IndexSet) {
        purchases.remove(atOffsets: indexSet)
        savePurchases()
        filterPurchases(with: searchText)
    }
    
    private func filterPurchases(with searchText: String) {
        if searchText.isEmpty {
            filteredPurchases = purchases.sorted { $0.date > $1.date }
        } else {
            filteredPurchases = purchases.filter { purchase in
                purchase.whatBought.localizedCaseInsensitiveContains(searchText) ||
                purchase.whereBought.localizedCaseInsensitiveContains(searchText) ||
                purchase.whyBought.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.date > $1.date }
        }
    }
    
    private func savePurchases() {
        if let encoded = try? JSONEncoder().encode(purchases) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadPurchases() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Purchase].self, from: data) {
            purchases = decoded
        }
        filterPurchases(with: searchText)
    }
    
    var sortedPurchases: [Purchase] {
        purchases.sorted { $0.date > $1.date }
    }
    
    func getPurchase(by id: UUID) -> Purchase? {
        return purchases.first { $0.id == id }
    }
}
