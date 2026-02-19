import Foundation

enum ProjectCategory: String, CaseIterable, Codable {
    case home = "Home"
    case garage = "Garage"
    case garden = "Garden"
    case repair = "Repair"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var date: Date
    var category: ProjectCategory
    var tools: [String]
    var materials: [String]
    var description: String
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, date: Date, category: ProjectCategory, tools: [String], materials: [String], description: String) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.category = category
        self.tools = tools
        self.materials = materials
        self.description = description
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(name: String? = nil, date: Date? = nil, category: ProjectCategory? = nil, tools: [String]? = nil, materials: [String]? = nil, description: String? = nil) {
        if let name = name { self.name = name }
        if let date = date { self.date = date }
        if let category = category { self.category = category }
        if let tools = tools { self.tools = tools }
        if let materials = materials { self.materials = materials }
        if let description = description { self.description = description }
        self.updatedAt = Date()
    }
}

extension Project {
    var primaryTool: String {
        return tools.first ?? "No tools"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var toolsString: String {
        return tools.joined(separator: ", ")
    }
    
    var materialsString: String {
        return materials.joined(separator: ", ")
    }
}
