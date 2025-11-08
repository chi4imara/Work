import Foundation

enum PlantStatus: String, CaseIterable {
    case recentlyFertilized = "recently_fertilized"
    case soonToFertilize = "soon_to_fertilize"
    case needsFertilizing = "needs_fertilizing"
    
    var displayName: String {
        switch self {
        case .recentlyFertilized:
            return "Recently fertilized"
        case .soonToFertilize:
            return "Soon to fertilize"
        case .needsFertilizing:
            return "Needs fertilizing"
        }
    }
    
    var emoji: String {
        switch self {
        case .recentlyFertilized:
            return "🟢"
        case .soonToFertilize:
            return "🟡"
        case .needsFertilizing:
            return "🔴"
        }
    }
}

enum FertilizerType: String, CaseIterable, Codable {
    case universal = "universal"
    case mineral = "mineral"
    case organic = "organic"
    case complex = "complex"
    case liquid = "liquid"
    case granular = "granular"
    
    var displayName: String {
        switch self {
        case .universal:
            return "Universal"
        case .mineral:
            return "Mineral"
        case .organic:
            return "Organic"
        case .complex:
            return "Complex"
        case .liquid:
            return "Liquid"
        case .granular:
            return "Granular"
        }
    }
}

struct Plant: Identifiable, Codable {
    let id: UUID
    var name: String
    var intervalDays: Int
    var lastFertilizedDate: Date
    var fertilizerType: FertilizerType
    var comment: String
    
    init(name: String, intervalDays: Int, lastFertilizedDate: Date, fertilizerType: FertilizerType, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.intervalDays = intervalDays
        self.lastFertilizedDate = lastFertilizedDate
        self.fertilizerType = fertilizerType
        self.comment = comment
    }
    
    var daysPassed: Int {
        let calendar = Calendar.current
        let today = Date()
        return calendar.dateComponents([.day], from: lastFertilizedDate, to: today).day ?? 0
    }
    
    var yellowThreshold: Int {
        return Int(floor(Double(intervalDays) * 0.7))
    }
    
    var status: PlantStatus {
        if daysPassed <= yellowThreshold {
            return .recentlyFertilized
        } else if daysPassed <= intervalDays {
            return .soonToFertilize
        } else {
            return .needsFertilizing
        }
    }
    
    var nextFertilizeDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: intervalDays, to: lastFertilizedDate) ?? Date()
    }
    
    var statusMessage: String {
        switch status {
        case .recentlyFertilized:
            return "Plant is in good condition, too early for next feeding."
        case .soonToFertilize:
            return "Soon it will be time for fertilization."
        case .needsFertilizing:
            return "Time to fertilize — interval exceeded!"
        }
    }
    
    var needsAttentionMessage: String? {
        return status == .needsFertilizing ? "This plant needs fertilization!" : nil
    }
}

struct FertilizationEntry: Identifiable, Codable {
    let id: UUID
    let plantId: UUID
    let date: Date
    let fertilizerType: FertilizerType
    let comment: String
    
    init(plantId: UUID, date: Date, fertilizerType: FertilizerType, comment: String = "") {
        self.id = UUID()
        self.plantId = plantId
        self.date = date
        self.fertilizerType = fertilizerType
        self.comment = comment
    }
}

struct UserNote: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, content: String = "") {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func update(title: String, content: String) {
        self.title = title
        self.content = content
        self.dateModified = Date()
    }
}

enum PlantFilter: String, CaseIterable, Codable {
    case all = "all"
    case needsFertilizing = "needs_fertilizing"
    
    var displayName: String {
        switch self {
        case .all:
            return "Show All"
        case .needsFertilizing:
            return "Needs Fertilizing"
        }
    }
}

enum PlantSortOption: String, CaseIterable, Codable {
    case byLastFertilized = "by_last_fertilized"
    case byName = "by_name"
    
    var displayName: String {
        switch self {
        case .byLastFertilized:
            return "Sort by Last Fertilized"
        case .byName:
            return "Sort by Name"
        }
    }
}

struct AppSettings: Codable {
    var hasCompletedOnboarding: Bool = false
    var currentFilter: PlantFilter = .all
    var currentSort: PlantSortOption = .byLastFertilized
    
    static let `default` = AppSettings()
}
