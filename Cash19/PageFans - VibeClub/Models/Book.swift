import Foundation

enum BookStatus: String, CaseIterable, Codable {
    case reading = "reading"
    case completed = "completed"
    case wantToRead = "wantToRead"
    
    var displayName: String {
        switch self {
        case .reading:
            return "Reading"
        case .completed:
            return "Completed"
        case .wantToRead:
            return "Want to Read"
        }
    }
    
    var badgeColor: String {
        switch self {
        case .reading:
            return "blue"
        case .completed:
            return "green"
        case .wantToRead:
            return "yellow"
        }
    }
}

struct Book: Identifiable, Codable {
    let id = UUID()
    var title: String
    var author: String?
    var status: BookStatus
    var rating: Int?
    var notes: String?
    var currentPage: Int?
    var totalPages: Int?
    var dateAdded: Date
    var dateCompleted: Date?
    var lastModified: Date
    
    init(title: String, author: String? = nil, status: BookStatus = .wantToRead) {
        self.title = title
        self.author = author
        self.status = status
        self.dateAdded = Date()
        self.lastModified = Date()
    }
    
    var progressText: String? {
        guard status == .reading else { return nil }
        
        if let current = currentPage, let total = totalPages {
            return "Page \(current) / \(total)"
        } else if let current = currentPage {
            return "Read \(current) pages"
        }
        return nil
    }
    
    var ratingText: String? {
        guard let rating = rating else { return nil }
        return "\(rating)/10"
    }
    
    mutating func updateStatus(_ newStatus: BookStatus) {
        status = newStatus
        lastModified = Date()
        
        switch newStatus {
        case .reading:
            rating = nil
            dateCompleted = nil
        case .completed:
            currentPage = nil
            totalPages = nil
            dateCompleted = Date()
        case .wantToRead:
            rating = nil
            currentPage = nil
            totalPages = nil
            dateCompleted = nil
        }
    }
}
