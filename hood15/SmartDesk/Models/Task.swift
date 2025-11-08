import Foundation

enum TaskType: String, CaseIterable, Codable {
    case homework = "Homework"
    case test = "Test"
}

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var type: TaskType
    var dueDate: Date
    var description: String?
    var subjectId: UUID
    var isCompleted: Bool
    
    init(title: String, type: TaskType, dueDate: Date, description: String? = nil, subjectId: UUID, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.type = type
        self.dueDate = dueDate
        self.description = description
        self.subjectId = subjectId
        self.isCompleted = isCompleted
    }
}
