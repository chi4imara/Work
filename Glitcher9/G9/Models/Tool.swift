import Foundation

struct Tool: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: String
    var condition: String
    var comment: String
    var dateCreated: Date
    
    init(name: String, type: String, condition: String, comment: String) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.condition = condition
        self.comment = comment
        self.dateCreated = Date()
    }
}

struct ToolType: Identifiable {
    let id = UUID()
    let name: String
    let tools: [Tool]
    
    var count: Int {
        tools.count
    }
}

enum ToolCondition: String, CaseIterable {
    case new = "New"
    case working = "Working"
    case needsRepair = "Needs Repair"
}

enum ToolTypeCategory: String, CaseIterable {
    case mechanical = "Mechanical"
    case woodworking = "Woodworking"
    case electrical = "Electrical"
}
