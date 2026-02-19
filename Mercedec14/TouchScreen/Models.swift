import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var avatar: String?
    var preferences: MassagePreferences
    var notificationSettings: NotificationSettings
    var stressLevel: Int
    
    init(name: String = "John Doe", email: String = "john@example.com") {
        self.id = UUID()
        self.name = name
        self.email = email
        self.preferences = MassagePreferences()
        self.notificationSettings = NotificationSettings()
        self.stressLevel = 5
    }
}

struct MassagePreferences: Codable {
    var preferredTypes: [MassageType]
    var preferredDuration: [SessionDuration]
    var maxPrice: Double
    var preferredTimeSlots: [String]
    
    init() {
        self.preferredTypes = [.relaxation]
        self.preferredDuration = [.sixty]
        self.maxPrice = 150.0
        self.preferredTimeSlots = ["Morning", "Evening"]
    }
}

struct NotificationSettings: Codable {
    var sessionReminders: Bool
    var promotions: Bool
    var masterRecommendations: Bool
    var progressUpdates: Bool
    
    init() {
        self.sessionReminders = true
        self.promotions = true
        self.masterRecommendations = true
        self.progressUpdates = false
    }
}

struct Master: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var rating: Double
    var reviewCount: Int
    var specialties: [MassageType]
    var experience: Int
    var pricePerHour: Double
    var availability: [String]
    var bio: String
    var imageUrl: String
    var isVerified: Bool
    
    init(id: UUID = UUID(), name: String, rating: Double, reviewCount: Int, specialties: [MassageType], experience: Int, pricePerHour: Double, availability: [String], bio: String, imageUrl: String = "", isVerified: Bool) {
        self.id = id
        self.name = name
        self.rating = rating
        self.reviewCount = reviewCount
        self.specialties = specialties
        self.experience = experience
        self.pricePerHour = pricePerHour
        self.availability = availability
        self.bio = bio
        self.imageUrl = imageUrl
        self.isVerified = isVerified
    }
}

struct Session: Identifiable, Codable {
    let id: UUID
    var title: String
    var master: Master
    var type: MassageType
    var duration: SessionDuration
    var date: Date
    var price: Double
    var status: SessionStatus
    var notes: String
    var location: SessionLocation
    var userRating: Int?
    var userReview: String?
    
    init(id: UUID = UUID(), title: String, master: Master, type: MassageType, duration: SessionDuration, date: Date, price: Double, status: SessionStatus, notes: String, location: SessionLocation, userRating: Int? = nil, userReview: String? = nil) {
        self.id = id
        self.title = title
        self.master = master
        self.type = type
        self.duration = duration
        self.date = date
        self.price = price
        self.status = status
        self.notes = notes
        self.location = location
        self.userRating = userRating
        self.userReview = userReview
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedPrice: String {
        return String(format: "$%.0f", price)
    }
}

enum MassageType: String, CaseIterable, Codable {
    case relaxation = "Relaxation"
    case antiStress = "Anti-Stress"
    case antiCellulite = "Anti-Cellulite"
    case sports = "Sports"
    case classic = "Classic"
    
    var icon: String {
        switch self {
        case .relaxation: return "leaf.fill"
        case .antiStress: return "heart.fill"
        case .antiCellulite: return "figure.walk"
        case .sports: return "dumbbell.fill"
        case .classic: return "hands.sparkles.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .relaxation: return .green
        case .antiStress: return .blue
        case .antiCellulite: return .purple
        case .sports: return .orange
        case .classic: return .pink
        }
    }
}

enum SessionDuration: Int, CaseIterable, Codable {
    case thirty = 30
    case sixty = 60
    case ninety = 90
    
    var displayName: String {
        return "\(self.rawValue) min"
    }
}

enum SessionStatus: String, CaseIterable, Codable {
    case scheduled = "Scheduled"
    case completed = "Completed"
    case cancelled = "Cancelled"
    case missed = "Missed"
    
    var color: Color {
        switch self {
        case .scheduled: return .blue
        case .completed: return .green
        case .cancelled: return .gray
        case .missed: return .red
        }
    }
}

enum SessionLocation: String, CaseIterable, Codable {
    case home = "At Home"
    case salon = "At Salon"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .salon: return "building.2.fill"
        }
    }
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    var isUnlocked: Bool
    var progress: Double
    let requiredCount: Int
    var currentCount: Int
    
    init(id: UUID = UUID(), title: String, description: String, icon: String, isUnlocked: Bool, progress: Double, requiredCount: Int, currentCount: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.progress = progress
        self.requiredCount = requiredCount
        self.currentCount = currentCount
    }
    
    static let defaultDefinitions: [(title: String, description: String, icon: String, requiredCount: Int)] = [
        ("First Steps", "Complete your first massage session", "star.fill", 1),
        ("Relaxation Master", "Complete 5 relaxation sessions", "leaf.fill", 5),
        ("Variety Seeker", "Try 3 different massage types", "sparkles", 3)
    ]
}

struct ProgressData: Codable {
    var stressLevels: [StressDataPoint]
    var sessionCounts: [SessionTypeCount]
    var weeklyProgress: [WeeklyProgress]
    
    init() {
        self.stressLevels = []
        self.sessionCounts = []
        self.weeklyProgress = []
    }
}

struct StressDataPoint: Identifiable, Codable {
    let id: UUID
    let date: Date
    let level: Int
    
    init(id: UUID = UUID(), date: Date, level: Int) {
        self.id = id
        self.date = date
        self.level = level
    }
}

struct SessionTypeCount: Identifiable, Codable {
    let id: UUID
    let type: MassageType
    let count: Int
    
    init(id: UUID = UUID(), type: MassageType, count: Int) {
        self.id = id
        self.type = type
        self.count = count
    }
}

struct WeeklyProgress: Identifiable, Codable {
    let id: UUID
    let week: String
    let sessionsCount: Int
    
    init(id: UUID = UUID(), week: String, sessionsCount: Int) {
        self.id = id
        self.week = week
        self.sessionsCount = sessionsCount
    }
}
