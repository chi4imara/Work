import Foundation

struct Purchase: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: String
    var amount: Double
    var date: Date
    var description: String
    
    init(name: String, category: String, amount: Double, date: Date = Date(), description: String = "") {
        self.name = name
        self.category = category
        self.amount = amount
        self.date = date
        self.description = description
    }
}

enum PurchaseCategory: String, CaseIterable {
    case outerwear = "Outerwear"
    case bottoms = "Bottoms"
    case shoes = "Shoes"
    case accessories = "Accessories"
    case jewelry = "Jewelry"
    
    var displayName: String {
        return self.rawValue
    }
}
