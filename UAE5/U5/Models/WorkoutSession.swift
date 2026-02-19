import Foundation

struct WorkoutSession: Identifiable, Codable {
    let id: UUID
    let workoutId: UUID
    let workoutName: String
    let exerciseCount: Int
    let performedAt: Date
    
    init(workout: Workout) {
        self.id = UUID()
        self.workoutId = workout.id
        self.workoutName = workout.name
        self.exerciseCount = workout.exerciseCount
        self.performedAt = Date()
    }
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: performedAt)
    }
    
    var dayMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: performedAt)
    }
}

