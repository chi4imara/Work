import Foundation

enum TaskStatus: String, CaseIterable, Codable, Equatable {
    case inProgress = "In Progress"
    case completed = "Completed"
    case overdue = "Overdue"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Task: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var deadline: Date
    var status: TaskStatus
    var createdAt: Date
    
    init(title: String, description: String = "", deadline: Date, status: TaskStatus = .inProgress) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.deadline = deadline
        self.status = status
        self.createdAt = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, deadline, status, createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        deadline = try container.decode(Date.self, forKey: .deadline)
        status = try container.decode(TaskStatus.self, forKey: .status)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(deadline, forKey: .deadline)
        try container.encode(status, forKey: .status)
        try container.encode(createdAt, forKey: .createdAt)
    }
    
    var isOverdue: Bool {
        return status != .completed && deadline < Date()
    }
    
    var actualStatus: TaskStatus {
        if status == .completed {
            return .completed
        } else if isOverdue {
            return .overdue
        } else {
            return .inProgress
        }
    }
}

extension Task {
    static let sampleTasks: [Task] = [
    ]
}
