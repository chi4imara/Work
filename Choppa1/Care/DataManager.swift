import Foundation
import Combine

class DataManager: ObservableObject {
    @Published var procedures: [Procedure] = []
    @Published var selectedCategory: ProcedureCategory? = nil
    @Published var selectedProduct: String? = nil
    
    private let userDefaults = UserDefaults.standard
    private let proceduresKey = "SavedProcedures"
    
    init() {
        loadProcedures()
    }
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
        saveProcedures()
    }
    
    func updateProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveProcedures()
        }
    }
    
    func deleteProcedure(_ procedure: Procedure) {
        procedures.removeAll { $0.id == procedure.id }
        saveProcedures()
    }
    
    func filteredProcedures() -> [Procedure] {
        var filtered = procedures
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if let product = selectedProduct {
            filtered = filtered.filter { procedure in
                let products = procedure.products.components(separatedBy: ",")
                return products.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(product) == .orderedSame }
            }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    func filteredAndSearchedProcedures(searchText: String) -> [Procedure] {
        var filtered = filteredProcedures()
        
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            filtered = filtered.filter { procedure in
                procedure.name.lowercased().contains(searchLower) ||
                procedure.products.lowercased().contains(searchLower) ||
                procedure.comment.lowercased().contains(searchLower) ||
                procedure.category.rawValue.lowercased().contains(searchLower)
            }
        }
        
        return filtered
    }
    
    func clearFilters() {
        selectedCategory = nil
        selectedProduct = nil
    }
    
    func getProductUsage() -> [ProductUsage] {
        var productCounts: [String: (count: Int, lastUsed: Date)] = [:]
        
        for procedure in procedures {
            let products = procedure.products.components(separatedBy: ",")
            for product in products {
                let trimmedProduct = product.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedProduct.isEmpty {
                    if let existing = productCounts[trimmedProduct] {
                        productCounts[trimmedProduct] = (
                            count: existing.count + 1,
                            lastUsed: max(existing.lastUsed, procedure.date)
                        )
                    } else {
                        productCounts[trimmedProduct] = (count: 1, lastUsed: procedure.date)
                    }
                }
            }
        }
        
        return productCounts.map { name, data in
            ProductUsage(name: name, usageCount: data.count, lastUsed: data.lastUsed)
        }.sorted { $0.usageCount > $1.usageCount }
    }
    
    func getStatistics() -> Statistics {
        let proceduresByCategory = Dictionary(grouping: procedures, by: { $0.category })
            .mapValues { $0.count }
        
        let topProducts = Array(getProductUsage().prefix(5))
        let recentProcedures = Array(procedures.sorted { $0.date > $1.date }.prefix(5))
        
        return Statistics(
            proceduresByCategory: proceduresByCategory,
            topProducts: topProducts,
            recentProcedures: recentProcedures
        )
    }
    
    private func saveProcedures() {
        if let encoded = try? JSONEncoder().encode(procedures) {
            userDefaults.set(encoded, forKey: proceduresKey)
        }
    }
    
    private func loadProcedures() {
        if let data = userDefaults.data(forKey: proceduresKey),
           let decoded = try? JSONDecoder().decode([Procedure].self, from: data) {
            procedures = decoded
        }
    }
}
