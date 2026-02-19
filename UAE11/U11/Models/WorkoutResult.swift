import Foundation

struct WorkoutResult: Identifiable, Codable {
    let id: UUID
    var weight: Double
    var reps: Int
    var date: Date
    
    init(weight: Double, reps: Int, date: Date = Date()) {
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.date = date
    }
    
    var formattedWeight: String {
        return String(format: "%.0f kg", weight)
    }
    
    var formattedReps: String {
        return "\(reps) reps"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var displayText: String {
        return "\(formattedWeight) × \(reps)"
    }
}
