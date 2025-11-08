import Foundation
import SwiftUI

enum HistoryEventType: String, Codable, CaseIterable {
    case added = "Added"
    case modified = "Modified"
    case deleted = "Deleted"
    
    var displayName: String {
        switch self {
        case .added:
            return "Added"
        case .modified:
            return "Modified"
        case .deleted:
            return "Deleted"
        }
    }
    
    var icon: String {
        switch self {
        case .added:
            return "plus.circle.fill"
        case .modified:
            return "pencil.circle.fill"
        case .deleted:
            return "trash.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .added:
            return .green
        case .modified:
            return .blue
        case .deleted:
            return .red
        }
    }
}

struct HistoryEvent: Identifiable, Codable {
    let id = UUID()
    let idea: Idea
    let eventType: HistoryEventType
    let timestamp: Date
    
    init(idea: Idea, eventType: HistoryEventType, timestamp: Date = Date()) {
        self.idea = idea
        self.eventType = eventType
        self.timestamp = timestamp
    }
    
    var displayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = formatter.string(from: timestamp)
        
        switch eventType {
        case .added:
            return "\(dateString) — Added idea: \(idea.title)"
        case .modified:
            return "\(dateString) — Modified idea: \(idea.title)"
        case .deleted:
            return "\(dateString) — Deleted idea: \(idea.title)"
        }
    }
}
