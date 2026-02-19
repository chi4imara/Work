import Foundation

enum TripType: String, CaseIterable, Codable, Identifiable {
    case hiking = "Hiking"
    case fishing = "Fishing"
    case outdoor = "Outdoor Trip"
    case other = "Other"
    
    var id: String {
        return self.rawValue
    }
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .hiking:
            return "figure.hiking"
        case .fishing:
            return "fish"
        case .outdoor:
            return "leaf"
        case .other:
            return "location"
        }
    }
}

struct Trip: Identifiable, Codable {
    let id: UUID
    var type: TripType
    var date: Date
    var route: String
    var duration: String
    var groupComposition: String
    var comment: String
    
    init(type: TripType, date: Date, route: String, duration: String, groupComposition: String, comment: String) {
        self.id = UUID()
        self.type = type
        self.date = date
        self.route = route
        self.duration = duration
        self.groupComposition = groupComposition
        self.comment = comment
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var hasComment: Bool {
        return !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct TripCategory: Identifiable {
    let id: UUID
    let type: TripType
    let trips: [Trip]
    
    var count: Int {
        return trips.count
    }
    
    var displayText: String {
        return "\(type.displayName) — \(count) records"
    }
    
    init(type: TripType, trips: [Trip]) {
        self.id = UUID()
        self.type = type
        self.trips = trips
    }
}
