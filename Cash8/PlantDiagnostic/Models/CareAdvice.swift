import Foundation

struct CareAdvice: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let content: String
    let category: Category
    
    enum Category: String, CaseIterable, Codable {
        case watering = "Watering"
        case repotting = "Repotting"
        case fertilizing = "Fertilizing"
        case lighting = "Lighting"
        case diseases = "Diseases"
        case general = "General"
    }
}

struct DiagnosticSymptom: Identifiable, Codable {
    let id: String
    let symptom: String
    let possibleCauses: [PossibleCause]
}

struct PossibleCause: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let symptoms: String
    let treatment: String
    let prevention: String
}

