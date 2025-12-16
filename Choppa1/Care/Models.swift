import Foundation

enum ProcedureCategory: String, CaseIterable, Codable {
    case nails = "Nails"
    case hair = "Hair"
    case skin = "Skin"
    
    var icon: String {
        switch self {
        case .nails:
            return "hand.point.up.left"
        case .hair:
            return "scissors"
        case .skin:
            return "face.smiling"
        }
    }
}

struct Procedure: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ProcedureCategory
    var date: Date
    var products: String
    var comment: String
    
    init(name: String, category: ProcedureCategory, date: Date, products: String, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.date = date
        self.products = products
        self.comment = comment
    }
}

struct ProductUsage: Identifiable {
    let id = UUID()
    let name: String
    let usageCount: Int
    let lastUsed: Date
}

struct Statistics {
    let proceduresByCategory: [ProcedureCategory: Int]
    let topProducts: [ProductUsage]
    let recentProcedures: [Procedure]
}

struct ProcedureTemplate: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ProcedureCategory
    var defaultProducts: String
    var defaultComment: String
    
    init(name: String, category: ProcedureCategory, defaultProducts: String = "", defaultComment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.defaultProducts = defaultProducts
        self.defaultComment = defaultComment
    }
}
