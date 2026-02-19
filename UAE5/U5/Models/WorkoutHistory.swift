import Foundation

struct WorkoutHistory: Identifiable, Codable {
    let id: UUID
    let workoutId: UUID
    let workoutName: String
    let exerciseCount: Int
    let completedAt: Date
    
    init(workout: Workout) {
        self.id = UUID()
        self.workoutId = workout.id
        self.workoutName = workout.name
        self.exerciseCount = workout.exerciseCount
        self.completedAt = Date()
    }
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: completedAt)
    }
    
    var dayMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: completedAt)
    }
}
