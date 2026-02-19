import Foundation

struct Workout: Identifiable, Codable, Equatable {
    let id: UUID
    var type: String
    var duration: Int
    var distance: Double
    var date: Date
    var comment: String
    
    init(type: String, duration: Int, distance: Double, date: Date, comment: String = "") {
        self.id = UUID()
        self.type = type
        self.duration = duration
        self.distance = distance
        self.date = date
        self.comment = comment
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var formattedDuration: String {
        return "\(duration) min"
    }
    
    var formattedDistance: String {
        return String(format: "%.1f km", distance)
    }
    
    var hasComment: Bool {
        return !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct WorkoutStatistics {
    let totalDistance: Double
    let totalDuration: Int
    let bestDistanceWorkout: Workout?
    let bestDurationWorkout: Workout?
    
    var formattedTotalDistance: String {
        return String(format: "%.1f km", totalDistance)
    }
    
    var formattedTotalDuration: String {
        let hours = totalDuration / 60
        let minutes = totalDuration % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes) min"
        }
    }
}

enum WorkoutType: String, CaseIterable {
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Swimming"
    case walking = "Walking"
    case elliptical = "Elliptical"
    
    var displayName: String {
        return self.rawValue
    }
}

extension UUID: Identifiable {
    public var id: UUID { self }
}
