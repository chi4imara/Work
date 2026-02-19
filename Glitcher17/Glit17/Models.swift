import Foundation
import Combine

struct Procedure: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: Category
    var frequency: Frequency
    var firstExecutionDate: Date
    var comment: String
    var isCompleted: Bool = false
    var completionHistory: [Date] = []
    
    enum Frequency: Codable, CaseIterable, Equatable {
        case daily
        case weekly
        case custom(days: Int)
        
        var displayText: String {
            switch self {
            case .daily:
                return "Daily"
            case .weekly:
                return "Weekly"
            case .custom(let days):
                return "Every \(days) days"
            }
        }
        
        static var allCases: [Frequency] {
            return [.daily, .weekly, .custom(days: 3)]
        }
    }
    
    func shouldShowOn(date: Date) -> Bool {
        let calendar = Calendar.current
        let daysSinceFirst = calendar.dateComponents([.day], from: firstExecutionDate, to: date).day ?? 0
        
        if daysSinceFirst < 0 { return false }
        
        switch frequency {
        case .daily:
            return true
        case .weekly:
            return daysSinceFirst % 7 == 0
        case .custom(let days):
            return daysSinceFirst % days == 0
        }
    }
    
    func isCompletedOn(date: Date) -> Bool {
        let calendar = Calendar.current
        return completionHistory.contains { calendar.isDate($0, inSameDayAs: date) }
    }
}

struct Category: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    
    static let defaultCategories = [
        Category(name: "Skin"),
        Category(name: "Hair"),
        Category(name: "Nails"),
        Category(name: "Eyebrows"),
        Category(name: "Body")
    ]
}

struct HistoryEntry: Identifiable, Codable {
    let id = UUID()
    let procedureId: UUID
    let procedureName: String
    let categoryName: String
    let completionDate: Date
}

class AppState: ObservableObject {
    @Published var procedures: [Procedure] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var history: [HistoryEntry] = []
    @Published var selectedDate: Date = Date()
    @Published var hasCompletedOnboarding: Bool = false
    
    init() {
        loadData()
    }
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
        
        if !categories.contains(where: { $0.name == procedure.category.name }) {
            categories.append(procedure.category)
        }
        
        saveData()
    }
    
    func updateProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveData()
        }
    }
    
    func deleteProcedure(_ procedure: Procedure) {
        procedures.removeAll { $0.id == procedure.id }
        history.removeAll { $0.procedureId == procedure.id }
        saveData()
    }
    
    func toggleProcedureCompletion(_ procedure: Procedure, on date: Date) {
        guard let index = procedures.firstIndex(where: { $0.id == procedure.id }) else { return }
        
        let calendar = Calendar.current
        let isAlreadyCompleted = procedures[index].completionHistory.contains { 
            calendar.isDate($0, inSameDayAs: date) 
        }
        
        if isAlreadyCompleted {
            procedures[index].completionHistory.removeAll {
                calendar.isDate($0, inSameDayAs: date) 
            }
            history.removeAll { 
                $0.procedureId == procedure.id && calendar.isDate($0.completionDate, inSameDayAs: date) 
            }
        } else {
            procedures[index].completionHistory.append(date)
            let historyEntry = HistoryEntry(
                procedureId: procedure.id,
                procedureName: procedure.name,
                categoryName: procedure.category.name,
                completionDate: date
            )
            history.append(historyEntry)
        }
        
        saveData()
    }
    
    func proceduresFor(date: Date) -> [Procedure] {
        return procedures.filter { $0.shouldShowOn(date: date) }
    }
    
    func proceduresFor(category: Category) -> [Procedure] {
        return procedures.filter { $0.category.name == category.name }
    }
    
    func categoriesWithProcedures() -> [Category] {
        let usedCategoryNames = Set(procedures.map { $0.category.name })
        return categories.filter { usedCategoryNames.contains($0.name) }
    }
    
    func procedureCount(for category: Category) -> Int {
        return procedures.filter { $0.category.name == category.name }.count
    }
    
    func allProceduresCompletedFor(date: Date) -> Bool {
        let todaysProcedures = proceduresFor(date: date)
        return !todaysProcedures.isEmpty && todaysProcedures.allSatisfy { $0.isCompletedOn(date: date) }
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(procedures) {
            UserDefaults.standard.set(encoded, forKey: "procedures")
        }
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: "categories")
        }
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: "history")
        }
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "procedures"),
           let decoded = try? JSONDecoder().decode([Procedure].self, from: data) {
            procedures = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: "categories"),
           let decoded = try? JSONDecoder().decode([Category].self, from: data) {
            categories = decoded
        } else {
            categories = Category.defaultCategories
        }
        
        if let data = UserDefaults.standard.data(forKey: "history"),
           let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            history = decoded.sorted { $0.completionDate > $1.completionDate }
        }
        
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}
