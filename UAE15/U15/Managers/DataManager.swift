import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var procedures: [Procedure] = []
    
    private let userDefaults = UserDefaults.standard
    private let proceduresKey = "SavedProcedures"
    
    private init() {
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
    
    func clearAllData() {
        procedures.removeAll()
        saveProcedures()
    }
        
    func filteredProcedures(searchText: String, category: ServiceCategory) -> [Procedure] {
        return procedures
            .filter { $0.matchesSearch(searchText) }
            .filter { $0.matchesCategory(category) }
            .sorted { $0.date > $1.date }
    }
        
    func getTotalProceduresCount() -> Int {
        return procedures.count
    }
    
    func getLastProcedureDate() -> Date? {
        return procedures.max(by: { $0.date < $1.date })?.date
    }
    
    func getServiceCounts() -> [ServiceType: Int] {
        var counts: [ServiceType: Int] = [:]
        
        for procedure in procedures {
            for service in procedure.services {
                counts[service.type, default: 0] += 1
            }
        }
        
        return counts
    }
    
    func getCategoryCounts() -> [ServiceCategory: Int] {
        var counts: [ServiceCategory: Int] = [:]
        
        for procedure in procedures {
            for category in procedure.categories {
                if category != .all {
                    counts[category, default: 0] += 1
                }
            }
        }
        
        return counts
    }
    
    func getMostFrequentBarber() -> String? {
        let barberCounts = Dictionary(grouping: procedures, by: { $0.barberName })
            .mapValues { $0.count }
        
        return barberCounts.max(by: { $0.value < $1.value })?.key
    }
    
    func getProceduresForPeriod(days: Int) -> [Procedure] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        return procedures.filter { $0.date >= startDate }
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
