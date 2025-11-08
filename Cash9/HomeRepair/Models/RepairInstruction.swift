import Foundation

struct RepairInstruction: Identifiable, Codable {
    let id = UUID()
    let title: String
    let category: RepairCategory
    let shortDescription: String
    let imageName: String
    let tools: [String]
    let steps: [RepairStep]
    let tips: [String]
    var isFavorite: Bool = false
    var isArchived: Bool = false
    var dateArchived: Date?
    var toolsChecked: [Bool]
    var stepsCompleted: [Bool]
    
    init(title: String, category: RepairCategory, shortDescription: String, imageName: String, tools: [String], steps: [RepairStep], tips: [String]) {
        self.title = title
        self.category = category
        self.shortDescription = shortDescription
        self.imageName = imageName
        self.tools = tools
        self.steps = steps
        self.tips = tips
        self.toolsChecked = Array(repeating: false, count: tools.count)
        self.stepsCompleted = Array(repeating: false, count: steps.count)
    }
}

struct RepairStep: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
}

enum RepairCategory: String, CaseIterable, Codable {
    case plumbing = "Plumbing"
    case electrical = "Electrical"
    case furniture = "Furniture"
    case decor = "Decor"
    case garden = "Garden"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .plumbing: return "drop.fill"
        case .electrical: return "bolt.fill"
        case .furniture: return "chair.fill"
        case .decor: return "paintbrush.fill"
        case .garden: return "leaf.fill"
        case .other: return "wrench.and.screwdriver.fill"
        }
    }
}

