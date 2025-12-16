import Foundation

enum CareEntryType: String, CaseIterable, Codable {
    case product = "product"
    case procedure = "procedure"
    
    var displayName: String {
        switch self {
        case .product:
            return "Product"
        case .procedure:
            return "Procedure"
        }
    }
    
    var icon: String {
        switch self {
        case .product:
            return "drop.fill"
        case .procedure:
            return "scissors"
        }
    }
}

struct CareEntry: Identifiable, Codable {
    let id: UUID
    var type: CareEntryType
    var name: String
    var date: Date
    var comment: String
    let createdAt: Date
    
    init(type: CareEntryType, name: String, date: Date, comment: String = "") {
        self.id = UUID()
        self.type = type
        self.name = name
        self.date = date
        self.comment = comment
        self.createdAt = Date()
    }
}

extension CareEntry {
    static let sampleData: [CareEntry] = [
        CareEntry(type: .product, name: "Keratin Restore Shampoo", date: Date().addingTimeInterval(-86400 * 7), comment: "Good cleansing, but requires conditioner"),
        CareEntry(type: .procedure, name: "Haircut", date: Date().addingTimeInterval(-86400 * 14), comment: "Trimmed the ends, loved the result"),
        CareEntry(type: .product, name: "Argan Oil Mask", date: Date().addingTimeInterval(-86400 * 3), comment: "Very moisturizing"),
        CareEntry(type: .procedure, name: "Hair Coloring", date: Date().addingTimeInterval(-86400 * 30), comment: "Beautiful blonde shade")
    ]
}
