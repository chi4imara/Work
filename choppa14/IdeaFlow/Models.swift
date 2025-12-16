import Foundation
import SwiftUI

enum ContentType: String, CaseIterable, Codable {
    case photo = "photo"
    case video = "video"
    case text = "text"
    
    var icon: String {
        switch self {
        case .photo: return "photo"
        case .video: return "video"
        case .text: return "text.alignleft"
        }
    }
    
    var displayName: String {
        switch self {
        case .photo: return "Photo"
        case .video: return "Video"
        case .text: return "Text"
        }
    }
}

enum ContentStatus: String, CaseIterable, Codable {
    case idea = "idea"
    case inProgress = "in_progress"
    case published = "published"
    
    var displayName: String {
        switch self {
        case .idea: return "Idea"
        case .inProgress: return "In Progress"
        case .published: return "Published"
        }
    }
    
    var color: Color {
        switch self {
        case .idea: return Color.theme.statusIdea
        case .inProgress: return Color.theme.statusInProgress
        case .published: return Color.theme.statusCompleted
        }
    }
}

struct ContentIdea: Identifiable, Codable {
    let id: UUID
    var title: String
    var contentType: ContentType
    var description: String
    var publishDate: Date?
    var status: ContentStatus
    var hashtags: String
    var createdDate: Date
    
    init(
        title: String,
        contentType: ContentType = .photo,
        description: String = "",
        publishDate: Date? = nil,
        status: ContentStatus = .idea,
        hashtags: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.contentType = contentType
        self.description = description
        self.publishDate = publishDate
        self.status = status
        self.hashtags = hashtags
        self.createdDate = Date()
    }
    
    init(
        id: UUID,
        title: String,
        contentType: ContentType,
        description: String,
        publishDate: Date?,
        status: ContentStatus,
        hashtags: String,
        createdDate: Date
    ) {
        self.id = id
        self.title = title
        self.contentType = contentType
        self.description = description
        self.publishDate = publishDate
        self.status = status
        self.hashtags = hashtags
        self.createdDate = createdDate
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var createdDate: Date
    var isPinned: Bool
    
    init(title: String, content: String, isPinned: Bool = false) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdDate = Date()
        self.isPinned = isPinned
    }
    
    init(id: UUID, title: String, content: String, createdDate: Date, isPinned: Bool) {
        self.id = id
        self.title = title
        self.content = content
        self.createdDate = createdDate
        self.isPinned = isPinned
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        return String(content.prefix(maxLength)) + "..."
    }
}

enum FilterType: String, CaseIterable {
    case all = "all"
    case ideas = "ideas"
    case inProgress = "in_progress"
    case published = "published"
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .ideas: return "Ideas"
        case .inProgress: return "In Progress"
        case .published: return "Published"
        }
    }
}

enum CalendarViewMode: String, CaseIterable {
    case calendar = "calendar"
    case list = "list"
    
    var icon: String {
        switch self {
        case .calendar: return "calendar"
        case .list: return "list.bullet"
        }
    }
    
    var displayName: String {
        switch self {
        case .calendar: return "Calendar"
        case .list: return "List"
        }
    }
}

struct IdeaID: Identifiable {
    let id: UUID
}

struct NoteID: Identifiable {
    let id: UUID
}
