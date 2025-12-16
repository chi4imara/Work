import Foundation

struct RepotRecord: Identifiable, Codable, Equatable {
    let id: UUID
    var plantName: String
    var repotDate: Date
    var potDiameter: Int?
    var potHeight: Int?
    var soilType: String?
    var hasDrainage: Bool
    var careNote: String?
    var createdAt: Date
    
    init(plantName: String, repotDate: Date, potDiameter: Int? = nil, potHeight: Int? = nil, soilType: String? = nil, hasDrainage: Bool = false, careNote: String? = nil) {
        self.id = UUID()
        self.plantName = plantName.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "  ", with: " ")
        self.repotDate = repotDate
        self.potDiameter = potDiameter
        self.potHeight = potHeight
        self.soilType = soilType
        self.hasDrainage = hasDrainage
        self.careNote = careNote
        self.createdAt = repotDate
    }
    
    var normalizedPlantName: String {
        return plantName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "  ", with: " ")
    }
    
    static func == (lhs: RepotRecord, rhs: RepotRecord) -> Bool {
        return lhs.id == rhs.id
    }
    
    var potDescription: String {
        var description = ""
        if let diameter = potDiameter {
            description += "Ø \(diameter) cm"
        }
        if let height = potHeight {
            if !description.isEmpty {
                description += ", height \(height) cm"
            } else {
                description += "Height \(height) cm"
            }
        }
        return description
    }
    
    var shortDescription: String {
        var parts: [String] = []
        if let diameter = potDiameter {
            parts.append("Ø \(diameter) cm")
        }
        if let soil = soilType, !soil.isEmpty {
            parts.append("Soil: \(soil)")
        }
        return parts.joined(separator: " • ")
    }
}
