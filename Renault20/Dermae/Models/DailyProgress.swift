import Foundation

struct DailyProgress: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var completedProcedures: [UUID] 
    var totalProcedures: Int
    var skinEntries: [SkinEntry]
    
    var completionPercentage: Double {
        guard totalProcedures > 0 else { return 0 }
        let pct = Double(completedProcedures.count) / Double(totalProcedures) * 100
        return min(max(pct, 0), 100)
    }
    
    var isFullyCompleted: Bool {
        completedProcedures.count == totalProcedures && totalProcedures > 0
    }
    
    init(date: Date = Date(), totalProcedures: Int = 0) {
        self.date = date
        self.completedProcedures = []
        self.totalProcedures = totalProcedures
        self.skinEntries = []
    }
    
    mutating func addCompletedProcedure(_ procedureId: UUID) {
        if !completedProcedures.contains(procedureId) {
            completedProcedures.append(procedureId)
        }
    }
    
    mutating func removeCompletedProcedure(_ procedureId: UUID) {
        completedProcedures.removeAll { $0 == procedureId }
    }
    
    mutating func addSkinEntry(_ entry: SkinEntry) {
        skinEntries.append(entry)
    }
}
