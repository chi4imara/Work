import Foundation

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    let date: String
    let createdAt: Date
    var text: String
    var isEdited: Bool
    var editedAt: Date?
    
    init(text: String, date: String = DateManager.shared.todayString()) {
        self.id = UUID()
        self.text = text
        self.date = date
        self.createdAt = Date()
        self.isEdited = false
        self.editedAt = nil
    }
    
    mutating func updateText(_ newText: String) {
        self.text = newText
        self.isEdited = true
        self.editedAt = Date()
    }
    
    var formattedDate: String {
        DateManager.shared.formatDateForDisplay(from: date)
    }
    
    var formattedTime: String {
        DateManager.shared.formatTime(from: createdAt)
    }
    
    var formattedEditTime: String? {
        guard let editedAt = editedAt else { return nil }
        return DateManager.shared.formatTime(from: editedAt)
    }
}
