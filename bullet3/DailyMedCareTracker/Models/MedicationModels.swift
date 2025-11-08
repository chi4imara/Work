import Foundation
import SwiftUI

struct Medication: Identifiable, Codable {
    let id: UUID
    var name: String
    var dosage: String
    var days: [WeekDay]
    var times: [String]
    var startDate: Date
    var endDate: Date?
    var comment: String?
    var isActive: Bool = true
    
    init(name: String, dosage: String, days: [WeekDay], times: [String], startDate: Date, endDate: Date? = nil, comment: String? = nil) {
        self.id = UUID()
        self.name = name
        self.dosage = dosage
        self.days = days
        self.times = times
        self.startDate = startDate
        self.endDate = endDate
        self.comment = comment
        self.isActive = true
    }
    
    enum WeekDay: String, CaseIterable, Codable {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
        
        var shortName: String {
            switch self {
            case .monday: return "Mon"
            case .tuesday: return "Tue"
            case .wednesday: return "Wed"
            case .thursday: return "Thu"
            case .friday: return "Fri"
            case .saturday: return "Sat"
            case .sunday: return "Sun"
            }
        }
        
        var dayNumber: Int {
            switch self {
            case .sunday: return 1
            case .monday: return 2
            case .tuesday: return 3
            case .wednesday: return 4
            case .thursday: return 5
            case .friday: return 6
            case .saturday: return 7
            }
        }
    }
}

struct Dose: Identifiable, Codable {
    let id = UUID()
    let medicationId: UUID
    let date: Date
    let time: String
    var status: DoseStatus = .notMarked
    
    enum DoseStatus: String, CaseIterable, Codable {
        case taken = "taken"
        case missed = "missed"
        case notMarked = "not_marked"
        
        var color: Color {
            switch self {
            case .taken: return .green
            case .missed: return .red
            case .notMarked: return .yellow
            }
        }
        
        var displayName: String {
            switch self {
            case .taken: return "Taken"
            case .missed: return "Missed"
            case .notMarked: return "—"
            }
        }
    }
}

struct MedicineReference: Identifiable, Codable {
    let id: UUID
    var name: String
    var purpose: String
    var recommendations: String
    var sideEffects: String?
    var doctorNotes: String?
    var lastModified: Date
    
    init(name: String, purpose: String, recommendations: String, sideEffects: String? = nil, doctorNotes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.purpose = purpose
        self.recommendations = recommendations
        self.sideEffects = sideEffects
        self.doctorNotes = doctorNotes
        self.lastModified = Date()
    }
    
    init(id: UUID, name: String, purpose: String, recommendations: String, sideEffects: String? = nil, doctorNotes: String? = nil, lastModified: Date) {
        self.id = id
        self.name = name
        self.purpose = purpose
        self.recommendations = recommendations
        self.sideEffects = sideEffects
        self.doctorNotes = doctorNotes
        self.lastModified = lastModified
    }
}

enum DayStatus {
    case allTaken
    case hasMissed
    case hasUnmarked
    case noDoses
    
    var color: Color {
        switch self {
        case .allTaken: return .green
        case .hasMissed: return .red
        case .hasUnmarked: return .yellow
        case .noDoses: return .clear
        }
    }
}

struct AnalyticsData {
    let totalDoses: Int
    let takenDoses: Int
    let missedDoses: Int
    let unmarkedDoses: Int
    
    var adherencePercentage: Int {
        guard totalDoses > 0 else { return 0 }
        return Int((Double(takenDoses) / Double(totalDoses)) * 100)
    }
    
    var adherenceLevel: AdherenceLevel {
        let percentage = adherencePercentage
        if percentage >= 80 { return .good }
        else if percentage >= 50 { return .medium }
        else { return .low }
    }
    
    enum AdherenceLevel {
        case good, medium, low
        
        var color: Color {
            switch self {
            case .good: return .green
            case .medium: return .yellow
            case .low: return .red
            }
        }
        
        var displayName: String {
            switch self {
            case .good: return "Good"
            case .medium: return "Medium"
            case .low: return "Low"
            }
        }
    }
}

enum CalendarPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
}

enum DayScheduleType: String, CaseIterable {
    case everyday = "Every day"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
    case custom = "Custom"
}
