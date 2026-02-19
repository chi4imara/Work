import Foundation

struct Procedure: Identifiable, Codable {
    let id: UUID
    var date: Date
    var type: ProcedureType
    var products: String
    var comment: String
    
    init(date: Date, type: ProcedureType, products: String, comment: String) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.products = products
        self.comment = comment
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

enum ProcedureType: String, CaseIterable, Codable {
    case shaving = "Shaving"
    case trimming = "Trimming"
    case beardCut = "Beard Cut"
    
    var displayName: String {
        return self.rawValue
    }
}

struct ProductStatistics: Identifiable {
    let id = UUID()
    let name: String
    let usageCount: Int
    let procedures: [Procedure]
}
