import Foundation

struct CookingStep: Identifiable, Codable, Hashable {
    let id: UUID
    var description: String
    
    init(description: String = "") {
        self.id = UUID()
        self.description = description
    }
    
    var isValid: Bool {
        return !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
