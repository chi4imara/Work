import Foundation
import SwiftUI

enum DreamStatus: String, CaseIterable, Codable {
    case waiting = "waiting"
    case fulfilled = "fulfilled"
    case notFulfilled = "not_fulfilled"
    
    var displayName: String {
        switch self {
        case .waiting:
            return "Waiting"
        case .fulfilled:
            return "Fulfilled"
        case .notFulfilled:
            return "Not Fulfilled"
        }
    }
    
    var color: Color {
        switch self {
        case .waiting:
            return AppColors.yellow
        case .fulfilled:
            return AppColors.green
        case .notFulfilled:
            return AppColors.red
        }
    }
}

struct Dream: Identifiable, Codable {
    let id: UUID
    var title: String
    var dreamDate: Date
    var description: String?
    var expectedEvent: String
    var checkDeadline: Date
    var tags: [String]
    var status: DreamStatus
    var outcomeDate: Date?
    var outcomeComment: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, dreamDate: Date, description: String? = nil, expectedEvent: String, checkDeadline: Date, tags: [String] = [], status: DreamStatus = .waiting, outcomeDate: Date? = nil, outcomeComment: String? = nil) {
        self.id = UUID()
        self.title = title
        self.dreamDate = dreamDate
        self.description = description
        self.expectedEvent = expectedEvent
        self.checkDeadline = checkDeadline
        self.tags = tags
        self.status = status
        self.outcomeDate = outcomeDate
        self.outcomeComment = outcomeComment
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func updateStatus(_ newStatus: DreamStatus, outcomeDate: Date? = nil, comment: String? = nil) {
        self.status = newStatus
        self.outcomeDate = outcomeDate
        self.outcomeComment = comment
        self.updatedAt = Date()
    }
}

struct Tag: Identifiable, Codable {
    let id: UUID
    var name: String
    var createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}
