import Foundation

enum ExerciseType: String, CaseIterable, Codable {
    case pushUps = "Push-ups"
    case abs = "Abs"
    case plank = "Plank"
    case squats = "Squats"
    case coreLifts = "Core Lifts"
    
    var unit: String {
        switch self {
        case .plank:
            return "seconds"
        default:
            return "reps"
        }
    }
    
    var description: String {
        switch self {
        case .pushUps:
            return "Standard push-ups with proper form. Count the number of repetitions."
        case .abs:
            return "Abdominal crunches or sit-ups. Count the number of repetitions."
        case .plank:
            return "Hold plank position. Record time in seconds."
        case .squats:
            return "Bodyweight squats with proper form. Count the number of repetitions."
        case .coreLifts:
            return "Core strengthening exercises like leg raises. Count the number of repetitions."
        }
    }
    
    var technique: String {
        switch self {
        case .pushUps:
            return "Start in plank position, lower body until chest nearly touches ground, push back up. Keep body straight throughout the movement."
        case .abs:
            return "Lie on back, knees bent, hands behind head. Lift shoulders off ground using abdominal muscles, lower back down."
        case .plank:
            return "Hold body in straight line from head to heels, supported on forearms and toes. Keep core tight and breathe normally."
        case .squats:
            return "Stand with feet shoulder-width apart, lower body as if sitting back into chair, keep knees behind toes, return to standing."
        case .coreLifts:
            return "Lie on back, lift legs and torso simultaneously to form V-shape, lower back down with control."
        }
    }
}

struct ExerciseResult: Codable, Identifiable {
    let id: UUID
    let type: ExerciseType
    let value: Int
    
    init(type: ExerciseType, value: Int) {
        self.id = UUID()
        self.type = type
        self.value = value
    }
}

struct Workout: Codable, Identifiable {
    let id: UUID
    let date: Date
    let exercises: [ExerciseResult]
    let comment: String
    
    init(date: Date, exercises: [ExerciseResult], comment: String = "", id: UUID = UUID()) {
        self.id = id
        self.date = date
        self.exercises = exercises
        self.comment = comment
    }
    
    var exercisesList: String {
        exercises.map { $0.type.rawValue }.joined(separator: ", ")
    }
    
    func getResult(for type: ExerciseType) -> Int? {
        exercises.first { $0.type == type }?.value
    }
    
    var hasExercises: Bool {
        !exercises.isEmpty
    }
}

enum WorkoutFilter: String, CaseIterable {
    case all = "All"
    case pushUps = "Push-ups"
    case abs = "Abs"
    case plank = "Plank"
    case squats = "Squats"
    case coreLifts = "Core Lifts"
    
    var exerciseType: ExerciseType? {
        switch self {
        case .all:
            return nil
        case .pushUps:
            return .pushUps
        case .abs:
            return .abs
        case .plank:
            return .plank
        case .squats:
            return .squats
        case .coreLifts:
            return .coreLifts
        }
    }
}

enum ProgressPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
    
    var days: Int? {
        switch self {
        case .week:
            return 7
        case .month:
            return 30
        case .year:
            return 365
        case .all:
            return nil
        }
    }
}

struct ProgressStats {
    let bestResult: Int
    let workoutCount: Int
    let lastWorkoutDate: Date?
    let averageResult: Double
    
    init(workouts: [Workout], exerciseType: ExerciseType) {
        let relevantResults = workouts.compactMap { workout in
            workout.getResult(for: exerciseType)
        }
        
        self.bestResult = relevantResults.max() ?? 0
        self.workoutCount = workouts.filter { workout in
            workout.getResult(for: exerciseType) != nil
        }.count
        self.lastWorkoutDate = workouts.first?.date
        self.averageResult = relevantResults.isEmpty ? 0 : Double(relevantResults.reduce(0, +)) / Double(relevantResults.count)
    }
}
