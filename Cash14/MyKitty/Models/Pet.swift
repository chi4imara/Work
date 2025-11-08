import Foundation

struct Pet: Identifiable, Codable {
    var id = UUID()
    var name: String
    var species: String
    var breed: String?
    var gender: Gender
    var birthDate: Date
    var adoptionDate: Date?
    var weight: Double?
    var identification: String?
    var color: String?
    var allergies: String?
    var notes: String?
    var isArchived: Bool = false
    var archivedDate: Date?
    
    enum Gender: String, CaseIterable, Codable {
        case male = "Male"
        case female = "Female"
        case unknown = "Not specified"
    }
    
    var age: String {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year, .month], from: birthDate, to: now)
        
        let years = ageComponents.year ?? 0
        let months = ageComponents.month ?? 0
        
        if years == 0 {
            return "\(months)m"
        } else if months == 0 {
            return "\(years)y"
        } else {
            return "\(years)y \(months)m"
        }
    }
    
    var speciesBreed: String {
        if let breed = breed, !breed.isEmpty {
            return "\(species) • \(breed)"
        }
        return species
    }
}

struct Vaccination: Identifiable, Codable {
    var id = UUID()
    var petId: UUID
    var vaccineName: String
    var date: Date
    var clinic: String?
    var serialNumber: String?
    var comment: String?
    var isArchived: Bool = false
    var archivedDate: Date?
}

struct Procedure: Identifiable, Codable {
    var id = UUID()
    var petId: UUID
    var type: ProcedureType
    var date: Date
    var result: String?
    var comment: String?
    var isArchived: Bool = false
    var archivedDate: Date?
    
    enum ProcedureType: String, CaseIterable, Codable {
        case parasite = "Parasite treatment"
        case examination = "Examination"
        case dental = "Dental cleaning"
        case surgery = "Surgery"
        case other = "Other"
    }
}

struct Note: Identifiable, Codable {
    var id = UUID()
    var petId: UUID
    var text: String
    var date: Date
    var isArchived: Bool = false
    var archivedDate: Date?
}
