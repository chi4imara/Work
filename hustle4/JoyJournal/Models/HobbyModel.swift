import Foundation
import SwiftUI

struct Hobby: Identifiable, Codable, Equatable {
    let id = UUID()
    var name: String
    var icon: String
    var sessions: [HobbySession]
    var createdAt: Date
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
        self.sessions = []
        self.createdAt = Date()
    }
    
    var totalSessions: Int {
        sessions.count
    }
    
    var totalTime: Int {
        sessions.reduce(0) { $0 + $1.duration }
    }
    
    var totalTimeFormatted: String {
        let hours = totalTime / 60
        let minutes = totalTime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var lastActivity: Date? {
        sessions.map { $0.date }.max()
    }
    
    var lastActivityFormatted: String {
        guard let lastActivity = lastActivity else { return "No activity" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: lastActivity)
    }
    
    var progressPercentage: Double {
        let targetSessions = 30
        return min(Double(totalSessions) / Double(targetSessions), 1.0)
    }
    
    static func == (lhs: Hobby, rhs: Hobby) -> Bool {
        return lhs.id == rhs.id
    }
}

struct HobbySession: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var duration: Int 
    var comment: String
    var isPlanned: Bool
    var isCompleted: Bool
    
    init(date: Date, duration: Int, comment: String, isPlanned: Bool = false) {
        self.date = date
        self.duration = duration
        self.comment = comment
        self.isPlanned = isPlanned
        self.isCompleted = !isPlanned
    }
    
    var durationFormatted: String {
        let hours = duration / 60
        let minutes = duration % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct HobbyIcons {
    static let availableIcons = [
        "paintbrush.fill",
        "music.note",
        "book.fill",
        "camera.fill",
        "gamecontroller.fill",
        "dumbbell.fill",
        "leaf.fill",
        "pencil.and.outline",
        "guitars.fill",
        "pianokeys",
        "microphone.fill",
        "theatermasks.fill",
        "film.fill",
        "photo.fill",
        "scissors",
        "hammer.fill",
        "wrench.and.screwdriver.fill",
        "car.fill",
        "bicycle",
        "figure.walk",
        "figure.run",
        "figure.yoga",
        "heart.fill",
        "star.fill",
        "sun.max.fill"
    ]
    
    static func randomIcon() -> String {
        availableIcons.randomElement() ?? "star.fill"
    }
}
