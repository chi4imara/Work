import Foundation

struct EntryModel: Codable, Identifiable {
    let id: UUID
    let plantId: UUID
    var date: Date
    var height: Double
    var leaves: Int
    var state: PlantState?
    var careTags: [CareTag]
    var note: String?
    
    init(plantId: UUID, date: Date = Date(), height: Double = 0, leaves: Int = 0, state: PlantState? = nil, careTags: [CareTag] = [], note: String? = nil) {
        self.id = UUID()
        self.plantId = plantId
        self.date = date
        self.height = height
        self.leaves = leaves
        self.state = state
        self.careTags = careTags
        self.note = note
    }
    
    var hasContent: Bool {
        return height > 0 || leaves > 0 || state != nil || !careTags.isEmpty || !(note?.isEmpty ?? true)
    }
    
    var shortSummary: String {
        var components: [String] = []
        
        if height > 0 {
            components.append("Height \(String(format: "%.1f", height)) cm")
        }
        
        if leaves > 0 {
            components.append("Leaves \(leaves)")
        }
        
        if let plantState = state {
            components.append("State: \(plantState.displayName)")
        }
        
        if !careTags.isEmpty {
            let careString = careTags.map { $0.displayName }.joined(separator: ", ")
            components.append("Care: \(careString)")
        }
        
        return components.joined(separator: " • ")
    }
}

enum PlantState: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case average = "Average"
    case poor = "Poor"
    
    var displayName: String {
        return self.rawValue
    }
}

enum CareTag: String, CaseIterable, Codable {
    case watering = "Watering"
    case spraying = "Spraying"
    case fertilizing = "Fertilizing"
    case repotting = "Repotting"
    
    var displayName: String {
        return self.rawValue
    }
}
