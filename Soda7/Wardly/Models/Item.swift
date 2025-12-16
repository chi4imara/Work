import Foundation

enum Priority: String, CaseIterable, Codable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var displayName: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        }
    }
}

enum ItemStatus: String, CaseIterable, Codable {
    case notPurchased = "Not Purchased"
    case purchased = "Purchased"
    
    var displayName: String {
        switch self {
        case .notPurchased: return "Not Purchased"
        case .purchased: return "Purchased"
        }
    }
}

struct Item: Identifiable, Codable {
    let id: UUID
    var name: String
    var estimatedPrice: Double
    var priority: Priority
    var comment: String
    var status: ItemStatus
    var dateAdded: Date
    var datePurchased: Date?
    
    init(name: String, estimatedPrice: Double, priority: Priority, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.estimatedPrice = estimatedPrice
        self.priority = priority
        self.comment = comment
        self.status = .notPurchased
        self.dateAdded = Date()
        self.datePurchased = nil
    }
    
    mutating func markAsPurchased() {
        self.status = .purchased
        self.datePurchased = Date()
    }
    
    mutating func markAsNotPurchased() {
        self.status = .notPurchased
        self.datePurchased = nil
    }
    
    var isImpulsive: Bool {
        return status == .purchased && priority == .low
    }
    
    var isConscious: Bool {
        return status == .purchased && (priority == .high || priority == .medium)
    }
}

enum FilterType: String, CaseIterable {
    case all = "All"
    case purchased = "Purchased"
    case waiting = "Waiting"
    
    var displayName: String {
        return self.rawValue
    }
}
