import Foundation

struct Ingredient: Identifiable, Codable, Hashable {
    let id: UUID
    var quantity: String
    var name: String
    
    init(quantity: String = "", name: String = "") {
        self.id = UUID()
        self.quantity = quantity
        self.name = name
    }
    
    var isValid: Bool {
        return !quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var displayText: String {
        return "\(quantity) \(name)"
    }
}
