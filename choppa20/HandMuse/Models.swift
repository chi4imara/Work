import Foundation

struct CraftIdea: Identifiable, Codable {
    let id: UUID
    var title: String
    var craftType: CraftType
    var description: String
    var materials: [String]
    var steps: [CraftStep]
    var isCompleted: Bool
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, craftType: CraftType, description: String, materials: [String] = [], steps: [CraftStep] = [], isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.craftType = craftType
        self.description = description
        self.materials = materials
        self.steps = steps
        self.isCompleted = isCompleted
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    init(id: UUID, title: String, craftType: CraftType, description: String, materials: [String], steps: [CraftStep], isCompleted: Bool, dateCreated: Date, dateModified: Date) {
        self.id = id
        self.title = title
        self.craftType = craftType
        self.description = description
        self.materials = materials
        self.steps = steps
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
    
    var completedStepsCount: Int {
        steps.filter { $0.isCompleted }.count
    }
    
    var totalStepsCount: Int {
        steps.count
    }
    
    var progressPercentage: Double {
        guard totalStepsCount > 0 else { return 0 }
        return Double(completedStepsCount) / Double(totalStepsCount)
    }
    
    var status: String {
        if isCompleted {
            return "Completed"
        } else if completedStepsCount > 0 {
            return "In Progress"
        } else {
            return "Not Started"
        }
    }
}

struct CraftStep: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
    }
}

enum CraftType: String, CaseIterable, Codable {
    case knitting = "Knitting"
    case crocheting = "Crocheting"
    case embroidery = "Embroidery"
    case scrapbooking = "Scrapbooking"
    case decor = "Decor"
    case sewing = "Sewing"
    case quilting = "Quilting"
    case jewelry = "Jewelry Making"
    case painting = "Painting"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    init(id: UUID, title: String, content: String, dateCreated: Date, dateModified: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        } else {
            let index = content.index(content.startIndex, offsetBy: maxLength)
            return String(content[..<index]) + "..."
        }
    }
}

enum IdeaFilter: String, CaseIterable {
    case all = "All"
    case inProgress = "In Progress"
    case completed = "Completed"
    case notStarted = "Not Started"
    
    var displayName: String {
        return self.rawValue
    }
}

enum TabItem: String, CaseIterable {
    case ideas = "Ideas"
    case notes = "Notes"
    case materials = "Materials"
    case inspiration = "Inspiration"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .ideas:
            return "paintbrush.fill"
        case .notes:
            return "note.text"
        case .materials:
            return "list.bullet"
        case .inspiration:
            return "lightbulb.fill"
        case .settings:
            return "gear"
        }
    }
}

struct Material: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var quantity: String
    var notes: String
    var dateAdded: Date
    var dateModified: Date
    
    init(name: String, category: String = "", quantity: String = "", notes: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.quantity = quantity
        self.notes = notes
        self.dateAdded = Date()
        self.dateModified = Date()
    }
}

struct Inspiration: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String
    var imageURL: String?
    var tags: [String]
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, description: String = "", imageURL: String? = nil, tags: [String] = []) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.tags = tags
        self.dateCreated = Date()
        self.dateModified = Date()
    }
}
