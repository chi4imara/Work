import Foundation
import SwiftUI
import Combine

class CareJournalViewModel: ObservableObject {
    @Published var entries: [CareEntry] = []
    @Published var selectedFilter: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "all"
        case products = "products"
        case procedures = "procedures"
        
        var displayName: String {
            switch self {
            case .all:
                return "All Records"
            case .products:
                return "Products"
            case .procedures:
                return "Procedures"
            }
        }
    }
    
    init() {
        loadEntries()
    }
    
    var filteredEntries: [CareEntry] {
        switch selectedFilter {
        case .all:
            return entries.sorted { $0.date > $1.date }
        case .products:
            return entries.filter { $0.type == .product }.sorted { $0.date > $1.date }
        case .procedures:
            return entries.filter { $0.type == .procedure }.sorted { $0.date > $1.date }
        }
    }
    
    var productUsageStats: [String: Int] {
        let products = entries.filter { $0.type == .product }
        var stats: [String: Int] = [:]
        
        for product in products {
            stats[product.name, default: 0] += 1
        }
        
        return stats
    }
    
    var frequentlyUsedProducts: [String] {
        return productUsageStats.filter { $0.value >= 3 }.keys.sorted()
    }
    
    var totalStats: (total: Int, products: Int, procedures: Int) {
        let products = entries.filter { $0.type == .product }.count
        let procedures = entries.filter { $0.type == .procedure }.count
        return (entries.count, products, procedures)
    }
    
    var recentProcedures: [CareEntry] {
        return entries
            .filter { $0.type == .procedure }
            .sorted { $0.date > $1.date }
            .prefix(5)
            .map { $0 }
    }
    
    func addEntry(_ entry: CareEntry) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: CareEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: CareEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func getUsageCount(for productName: String) -> Int {
        return productUsageStats[productName] ?? 0
    }
    
    func getEntriesForProduct(_ productName: String) -> [CareEntry] {
        return entries.filter { $0.name == productName && $0.type == .product }
    }
    
    func getEntry(by id: UUID) -> CareEntry? {
        return entries.first { $0.id == id }
    }
    
    func deleteEntry(by id: UUID) {
        entries.removeAll { $0.id == id }
        saveEntries()
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "CareEntries"),
           let decodedEntries = try? JSONDecoder().decode([CareEntry].self, from: data) {
            self.entries = decodedEntries
        } else {
            self.entries = []
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "CareEntries")
        }
    }
}
