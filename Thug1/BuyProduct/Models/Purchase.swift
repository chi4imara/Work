import Foundation

enum PurchaseCategory: String, CaseIterable, Codable {
    case furniture = "Furniture"
    case appliances = "Appliances"
    case electronics = "Electronics"
    case other = "Other"
}

enum PurchaseStatus: String, CaseIterable {
    case normal = "Normal"
    case soonReplacement = "Soon Replacement"
    case overdue = "Overdue"
}

struct Purchase: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: PurchaseCategory
    var purchaseDate: Date
    var serviceLifeYears: Int
    var comment: String
    var isFavorite: Bool
    var dateAdded: Date
    var dateUpdated: Date
    
    init(name: String, category: PurchaseCategory, purchaseDate: Date, serviceLifeYears: Int, comment: String = "", isFavorite: Bool = false) {
        self.name = name
        self.category = category
        self.purchaseDate = purchaseDate
        self.serviceLifeYears = serviceLifeYears
        self.comment = comment
        self.isFavorite = isFavorite
        self.dateAdded = Date()
        self.dateUpdated = Date()
    }
    
    var endDate: Date {
        Calendar.current.date(byAdding: .year, value: serviceLifeYears, to: purchaseDate) ?? purchaseDate
    }
    
    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
    }
    
    var status: PurchaseStatus {
        let remaining = daysRemaining
        if remaining > 180 {
            return .normal
        } else if remaining >= 0 {
            return .soonReplacement
        } else {
            return .overdue
        }
    }
}
