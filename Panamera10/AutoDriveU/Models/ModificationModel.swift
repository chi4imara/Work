import Foundation

enum ModificationStatus: String, CaseIterable, Identifiable, Codable {
    case plan = "Plan"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .plan:
            return "Plan"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}

enum ModificationCategory: String, CaseIterable, Identifiable, Codable {
    case exterior = "Exterior"
    case technical = "Technical"
    case interior = "Interior"
    case electrical = "Electrical"
    case other = "Other"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .exterior:
            return "Exterior Tuning"
        case .technical:
            return "Technical"
        case .interior:
            return "Interior"
        case .electrical:
            return "Electrical"
        case .other:
            return "Other"
        }
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case priority = "Priority"
    case cost = "Cost"
    case category = "Category"
    case status = "Status"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .priority:
            return "By Priority"
        case .cost:
            return "By Cost"
        case .category:
            return "By Category"
        case .status:
            return "By Status"
        }
    }
}

struct Modification: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: ModificationCategory
    var budget: Double
    var status: ModificationStatus
    var description: String
    var createdAt: Date
    
    init(name: String, category: ModificationCategory, budget: Double, status: ModificationStatus, description: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.budget = budget
        self.status = status
        self.description = description
        self.createdAt = Date()
    }
}

struct CategorySummary: Identifiable {
    let id = UUID()
    let category: ModificationCategory
    let count: Int
    let totalBudget: Double
}
