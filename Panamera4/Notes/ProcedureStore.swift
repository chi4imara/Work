import Foundation
import SwiftUI
import Combine

class ProcedureStore: ObservableObject {
    @Published var procedures: [HairCareProcedure] = []
    
    private let userDefaults = UserDefaults.standard
    private let proceduresKey = "SavedProcedures"
    
    init() {
        loadProcedures()
    }
    
    func addProcedure(_ procedure: HairCareProcedure) {
        procedures.append(procedure)
        saveProcedures()
    }
    
    func updateProcedure(_ procedure: HairCareProcedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveProcedures()
        }
    }
    
    func deleteProcedure(_ procedure: HairCareProcedure) {
        procedures.removeAll { $0.id == procedure.id }
        saveProcedures()
    }
    
    func filteredProcedures(searchText: String) -> [HairCareProcedure] {
        if searchText.isEmpty {
            return procedures.sorted { $0.date > $1.date }
        } else {
            return procedures
                .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                .sorted { $0.date > $1.date }
        }
    }
    
    func proceduresForCategory(_ category: ProcedureCategory) -> [HairCareProcedure] {
        return procedures
            .filter { $0.category == category }
            .sorted { $0.date > $1.date }
    }
    
    func totalProceduresCount() -> Int {
        return procedures.count
    }
    
    func mostFrequentCategory() -> ProcedureCategory? {
        let categoryGroups = Dictionary(grouping: procedures) { $0.category }
        return categoryGroups.max { $0.value.count < $1.value.count }?.key
    }
    
    func lastProcedure() -> HairCareProcedure? {
        return procedures.max { $0.date < $1.date }
    }
    
    func categoryStatistics() -> [CategoryStatistics] {
        let categoryGroups = Dictionary(grouping: procedures) { $0.category }
        return categoryGroups.map { CategoryStatistics(category: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
    
    func recentProcedures(limit: Int = 5) -> [HairCareProcedure] {
        return procedures
            .sorted { $0.date > $1.date }
            .prefix(limit)
            .map { $0 }
    }
    
    func categoriesWithCounts() -> [(category: ProcedureCategory, count: Int)] {
        let categoryGroups = Dictionary(grouping: procedures) { $0.category }
        return ProcedureCategory.allCases.compactMap { category in
            let count = categoryGroups[category]?.count ?? 0
            return count > 0 ? (category: category, count: count) : nil
        }.sorted { $0.count > $1.count }
    }
    
    private func saveProcedures() {
        if let encoded = try? JSONEncoder().encode(procedures) {
            userDefaults.set(encoded, forKey: proceduresKey)
        }
    }
    
    private func loadProcedures() {
        if let data = userDefaults.data(forKey: proceduresKey),
           let decoded = try? JSONDecoder().decode([HairCareProcedure].self, from: data) {
            procedures = decoded
        }
    }
}
