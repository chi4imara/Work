import Foundation

struct Product: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var quantity: String
    var isCompleted: Bool = false
    var dateCreated: Date = Date()
    
    init(name: String, category: String, quantity: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.quantity = quantity
    }
}
