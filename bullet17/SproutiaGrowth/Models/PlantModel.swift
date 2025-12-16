import Foundation

struct PlantModel: Codable, Identifiable {
    let id: UUID
    var name: String
    var location: String?
    var type: PlantType?
    var status: PlantStatus
    var note: String?
    var createdAt: Date
    
    init(name: String, location: String? = nil, type: PlantType? = nil, status: PlantStatus = .healthy, note: String? = nil) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.type = type
        self.status = status
        self.note = note
        self.createdAt = Date()
    }
    
    var entries: [EntryModel] = []
    
    var lastEntry: EntryModel? {
        return entries.sorted { $0.date > $1.date }.first
    }
    
    var lastMeasurement: (height: Double?, leaves: Int?) {
        for entry in entries.sorted(by: { $0.date > $1.date }) {
            if entry.height > 0 || entry.leaves > 0 {
                return (entry.height > 0 ? entry.height : nil, entry.leaves > 0 ? entry.leaves : nil)
            }
        }
        return (nil, nil)
    }
    
    var lastRecordDate: Date? {
        return lastEntry?.date
    }
}

enum PlantType: String, CaseIterable, Codable {
    case indoor = "Indoor"
    case succulent = "Succulent"
    case herb = "Herb"
    case flowering = "Flowering"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

enum PlantStatus: String, CaseIterable, Codable {
    case healthy = "Healthy"
    case needsCare = "Needs Care"
    case monitoring = "Monitoring"
    
    var displayName: String {
        return self.rawValue
    }
}
