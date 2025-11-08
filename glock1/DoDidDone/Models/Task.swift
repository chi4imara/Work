import Foundation

struct Task: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var category: TaskCategory
    var isCompleted: Bool
    var createdAt: Date
    
    init(title: String, description: String = "", category: TaskCategory = .other, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}

enum TaskCategory: String, CaseIterable, Codable, Identifiable {
    case electrical = "Electrical"
    case plumbing = "Plumbing"
    case shopping = "Shopping"
    case other = "Other"
    
    var id: String { rawValue }
    
    var displayName: String {
        return self.rawValue
    }
}

enum TaskFilter: String, CaseIterable {
    case all = "All"
    case active = "Active"
    case completed = "Completed"
}
