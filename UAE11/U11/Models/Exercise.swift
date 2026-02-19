import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var results: [WorkoutResult]
    var createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.results = []
        self.createdAt = Date()
    }
    
    var lastResult: WorkoutResult? {
        return results.sorted(by: { $0.date > $1.date }).first
    }
    
    var maxWeight: Double {
        return results.map { $0.weight }.max() ?? 0
    }
    
    var maxReps: Int {
        return results.map { $0.reps }.max() ?? 0
    }
    
    var totalRecords: Int {
        return results.count
    }
    
    var firstRecordDate: Date? {
        return results.sorted(by: { $0.date < $1.date }).first?.date
    }
    
    var lastRecordDate: Date? {
        return results.sorted(by: { $0.date > $1.date }).first?.date
    }
}
