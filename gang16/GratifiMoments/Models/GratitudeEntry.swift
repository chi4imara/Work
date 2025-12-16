import Foundation
import SwiftUI

struct GratitudeEntry: Identifiable, Codable {
    let id: UUID
    let date: String
    let createdAt: Date
    var text: String
    var edited: Bool
    var editedAt: Date?
    
    init(text: String, date: String = DateFormatter.dayFormatter.string(from: Date())) {
        self.id = UUID()
        self.text = text
        self.date = date
        self.createdAt = Date()
        self.edited = false
        self.editedAt = nil
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self.date) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMMM d, yyyy"
            displayFormatter.locale = Locale(identifier: "en_US")
            return displayFormatter.string(from: date)
        }
        return self.date
    }
    
    var displayTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    mutating func updateText(_ newText: String) {
        self.text = newText
        self.edited = true
        self.editedAt = Date()
    }
}

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
