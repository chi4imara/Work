import Foundation
import SwiftUI

struct Memory: Identifiable, Codable {
    let id = UUID()
    var text: String
    var date: Date
    var isImportant: Bool
    let createdAt: Date
    
    init(text: String, date: Date, isImportant: Bool = false) {
        self.text = text
        self.date = date
        self.isImportant = isImportant
        self.createdAt = Date()
    }
    
    var shortText: String {
        if text.count <= 30 {
            return text
        } else {
            return String(text.prefix(30)) + "..."
        }
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: createdAt)
    }
}
