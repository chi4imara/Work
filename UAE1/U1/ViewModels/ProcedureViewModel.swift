import Foundation
import Combine

class ProcedureViewModel: ObservableObject {
    @Published var procedures: [Procedure] = []
    @Published var isFirstLaunch: Bool = true
    @Published var showOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let proceduresKey = "SavedProcedures"
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        loadProcedures()
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
        showOnboarding = isFirstLaunch
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        isFirstLaunch = false
        showOnboarding = false
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
    
    private func saveProcedures() {
        if let encoded = try? JSONEncoder().encode(procedures) {
            userDefaults.set(encoded, forKey: proceduresKey)
        }
    }
    
    private func loadProcedures() {
        if let data = userDefaults.data(forKey: proceduresKey),
           let decoded = try? JSONDecoder().decode([Procedure].self, from: data) {
            procedures = decoded.sorted { $0.date > $1.date }
        }
    }
    
    var lastProcedure: Procedure? {
        procedures.first
    }
    
    var sortedProcedures: [Procedure] {
        procedures.sorted { $0.date > $1.date }
    }
    
    var allProducts: [String] {
        let products = procedures.compactMap { procedure in
            procedure.product.isEmpty ? nil : procedure.product
        }
        return Array(Set(products)).sorted()
    }
    
    func proceduresUsing(product: String) -> [Procedure] {
        procedures.filter { $0.product == product }.sorted { $0.date > $1.date }
    }
    
    func productUsageCount(product: String) -> Int {
        procedures.filter { $0.product == product }.count
    }
    
    func proceduresFor(date: Date) -> [Procedure] {
        let calendar = Calendar.current
        return procedures.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func datesWithProcedures(in month: Date) -> Set<Date> {
        let calendar = Calendar.current
        let monthProcedures = procedures.filter { 
            calendar.isDate($0.date, equalTo: month, toGranularity: .month)
        }
        return Set(monthProcedures.map { calendar.startOfDay(for: $0.date) })
    }
    
    func proceduresGroupedByMonth() -> [(String, [Procedure])] {
        let grouped = Dictionary(grouping: sortedProcedures) { $0.monthYear }
        return grouped.sorted { first, second in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            let firstDate = formatter.date(from: first.key) ?? Date.distantPast
            let secondDate = formatter.date(from: second.key) ?? Date.distantPast
            return firstDate > secondDate
        }
    }
}
