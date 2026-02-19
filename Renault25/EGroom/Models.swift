import Foundation

struct Procedure: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: ProcedureCategory
    var frequency: String
    var notes: String
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var completionDates: [Date] = []
    
    enum ProcedureCategory: String, CaseIterable, Codable, Comparable {
        case skincare = "Skincare"
        case beard = "Beard"
        case hair = "Hair"
        case nails = "Nails"
        case health = "Health"
        case style = "Style"
        
        static func < (lhs: ProcedureCategory, rhs: ProcedureCategory) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        var icon: String {
            switch self {
            case .skincare: return "face.smiling"
            case .beard: return "mustache"
            case .hair: return "scissors"
            case .nails: return "hand.raised"
            case .health: return "heart"
            case .style: return "tshirt"
            }
        }
    }
}

struct HealthMetric: Identifiable, Codable {
    let id = UUID()
    var name: String
    var value: String
    var unit: String
    var date: Date = Date()
    
    static let defaultMetrics = [
        HealthMetric(name: "Weight", value: "", unit: "kg"),
        HealthMetric(name: "Pulse", value: "", unit: "bpm"),
        HealthMetric(name: "Steps", value: "", unit: "steps"),
        HealthMetric(name: "Water", value: "", unit: "L")
    ]
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var completionDate: Date?
    
    static let dailyChallenges = [
        Challenge(title: "5 minutes face care", description: "Take 5 minutes for your skincare routine"),
        Challenge(title: "Check your diet", description: "Review what you ate today"),
        Challenge(title: "10,000 steps", description: "Walk at least 10,000 steps today"),
        Challenge(title: "Drink 2L water", description: "Stay hydrated throughout the day"),
        Challenge(title: "Beard grooming", description: "Trim and care for your beard"),
        Challenge(title: "Exercise 30 min", description: "Do any physical activity for 30 minutes")
    ]
}

struct DailyProgress: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var completedProcedures: [UUID] = []
    var healthMetrics: [HealthMetric] = []
    var completedChallenge: Challenge?
    var careBlockDone: Bool = false
    var styleBlockDone: Bool = false
    var progressPercentage: Double {
        let totalTasks = 4.0
        var completed = 0.0
        if careBlockDone { completed += 1 }
        if !healthMetrics.isEmpty { completed += 1 }
        if styleBlockDone { completed += 1 }
        if completedChallenge?.isCompleted == true { completed += 1 }
        return totalTasks > 0 ? completed / totalTasks : 0
    }
}
