import Foundation

struct Plant: Identifiable, Codable, Equatable {
    let id = UUID()
    var name: String
    var category: PlantCategory
    var careSchedule: CareSchedule
    var notes: String
    var isFavorite: Bool
    var isArchived: Bool
    var dateAdded: Date
    var imageData: Data?
    
    init(name: String, category: PlantCategory, careSchedule: CareSchedule = CareSchedule(), notes: String = "", isFavorite: Bool = false) {
        self.name = name
        self.category = category
        self.careSchedule = careSchedule
        self.notes = notes
        self.isFavorite = isFavorite
        self.isArchived = false
        self.dateAdded = Date()
        self.imageData = nil
    }
}

enum PlantCategory: String, CaseIterable, Codable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case aquatic = "Aquatic"
    
    var displayName: String {
        return rawValue
    }
}

struct CareSchedule: Codable, Equatable {
    var wateringFrequency: Int
    var fertilizingFrequency: Int
    var repottingFrequency: Int
    var cleaningFrequency: Int
    var generalCareFrequency: Int 
    
    init(wateringFrequency: Int = 7, fertilizingFrequency: Int = 30, repottingFrequency: Int = 365, cleaningFrequency: Int = 14, generalCareFrequency: Int = 7) {
        self.wateringFrequency = wateringFrequency
        self.fertilizingFrequency = fertilizingFrequency
        self.repottingFrequency = repottingFrequency
        self.cleaningFrequency = cleaningFrequency
        self.generalCareFrequency = generalCareFrequency
    }
}

