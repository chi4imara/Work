import Foundation

struct BookModel: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var author: String?
    var totalPages: Int32
    var currentPages: Int32
    var dateAdded: Date
    var dateCompleted: Date?
    var isCompleted: Bool
    var readingProgress: [ReadingProgressModel]
    
    init(title: String, author: String?, totalPages: Int32) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.totalPages = totalPages
        self.currentPages = 0
        self.dateAdded = Date()
        self.dateCompleted = nil
        self.isCompleted = false
        self.readingProgress = []
    }
}

extension BookModel {
    var progressPercentage: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPages) / Double(totalPages) * 100
    }
    
    var progressText: String {
        return "Read \(currentPages) / \(totalPages) pages"
    }
    
    var statusText: String {
        return isCompleted ? "Completed" : "In Progress"
    }
    
    var readingProgressArray: [ReadingProgressModel] {
        return readingProgress.sorted { $0.date > $1.date }
    }
}

struct ReadingProgressModel: Codable, Identifiable, Equatable {
    let id: UUID
    let date: Date
    let pagesRead: Int32
    
    init(pagesRead: Int32) {
        self.id = UUID()
        self.date = Date()
        self.pagesRead = pagesRead
    }
}

extension ReadingProgressModel {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var progressText: String {
        return "\(formattedDate) — \(pagesRead) pages"
    }
}
