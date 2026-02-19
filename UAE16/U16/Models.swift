import Foundation

enum MuscleGroup: String, CaseIterable, Identifiable, Codable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case cardio = "Cardio"
    case other = "Other"
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue
    }
}

struct Workout: Identifiable, Codable {
    let id: UUID
    var date: Date
    var muscleGroups: Set<MuscleGroup>
    var comment: String
    var otherMuscleGroup: String?
    
    init(date: Date, muscleGroups: Set<MuscleGroup>, comment: String = "", otherMuscleGroup: String? = nil) {
        self.id = UUID()
        self.date = date
        self.muscleGroups = muscleGroups
        self.comment = comment
        self.otherMuscleGroup = otherMuscleGroup
    }
    
    enum CodingKeys: String, CodingKey {
        case id, date, comment, otherMuscleGroup
        case muscleGroupsArray
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        let muscleGroupsArray = try container.decode([MuscleGroup].self, forKey: .muscleGroupsArray)
        muscleGroups = Set(muscleGroupsArray)
        comment = try container.decode(String.self, forKey: .comment)
        otherMuscleGroup = try container.decodeIfPresent(String.self, forKey: .otherMuscleGroup)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(Array(muscleGroups), forKey: .muscleGroupsArray)
        try container.encode(comment, forKey: .comment)
        try container.encodeIfPresent(otherMuscleGroup, forKey: .otherMuscleGroup)
    }
    
    var muscleGroupsString: String {
        let groups = muscleGroups.map { $0.displayName }.sorted()
        if let other = otherMuscleGroup, !other.isEmpty, muscleGroups.contains(.other) {
            let filteredGroups = groups.filter { $0 != "Other" }
            return (filteredGroups + [other]).joined(separator: ", ")
        }
        return groups.joined(separator: ", ")
    }
    
    var isLastVisit: Bool {
        return false
    }
}

enum TimePeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
    
    var displayName: String {
        return rawValue
    }
}

struct ProgressStats {
    let totalWorkouts: Int
    let lastVisitDate: Date?
    let mostTrainedMuscleGroup: MuscleGroup?
    let uniqueMuscleGroups: Int
    let workoutsInPeriod: [Date: Int]
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}
