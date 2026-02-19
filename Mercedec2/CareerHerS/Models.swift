import Foundation
import SwiftUI

struct User: Codable, Identifiable {
    let id: UUID
    var name: String
    var email: String
    var avatar: String?
    var currentGoal: String
    var desiredPosition: String
    var learningPace: LearningPace
    var notificationsEnabled: Bool
    var weeklyReportEnabled: Bool
    
    init(name: String = "", email: String = "", currentGoal: String = "", desiredPosition: String = "", learningPace: LearningPace = .medium, notificationsEnabled: Bool = true, weeklyReportEnabled: Bool = true) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.currentGoal = currentGoal
        self.desiredPosition = desiredPosition
        self.learningPace = learningPace
        self.notificationsEnabled = notificationsEnabled
        self.weeklyReportEnabled = weeklyReportEnabled
    }
}

enum LearningPace: String, CaseIterable, Codable {
    case slow = "Slow"
    case medium = "Medium"
    case intensive = "Intensive"
}

struct Skill: Codable, Identifiable {
    let id: UUID
    let name: String
    let icon: String
    var progress: Double
    var isSelected: Bool
    
    init(name: String, icon: String, progress: Double = 0.0, isSelected: Bool = false) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.progress = progress
        self.isSelected = isSelected
    }
}

struct Course: Codable, Identifiable {
    let id: UUID
    let title: String
    let skill: String
    let duration: String
    let level: CourseLevel
    var progress: Double
    var isStarted: Bool
    var isCompleted: Bool
    let description: String
    
    init(title: String, skill: String, duration: String, level: CourseLevel, progress: Double = 0.0, isStarted: Bool = false, isCompleted: Bool = false, description: String = "") {
        self.id = UUID()
        self.title = title
        self.skill = skill
        self.duration = duration
        self.level = level
        self.progress = progress
        self.isStarted = isStarted
        self.isCompleted = isCompleted
        self.description = description
    }
}

enum CourseLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct Goal: Codable, Identifiable {
    let id: UUID
    var title: String
    var skill: String
    var deadline: Date
    var priority: Priority
    var isCompleted: Bool
    
    init(title: String, skill: String, deadline: Date, priority: Priority, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.skill = skill
        self.deadline = deadline
        self.priority = priority
        self.isCompleted = isCompleted
    }
}

enum Priority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct CourseFilter {
    var skillType: String?
    var level: CourseLevel?
    var timeAvailable: TimeFilter?
    
    var isActive: Bool {
        return skillType != nil || level != nil || timeAvailable != nil
    }
}

enum TimeFilter: String, CaseIterable {
    case short = "Up to 15 min"
    case medium = "15-30 min"
    case long = "30+ min"
}

struct Achievement: Codable, Identifiable {
    let id: UUID
    let title: String
    let skill: String
    let completedDate: Date
    let type: AchievementType
    
    init(title: String, skill: String, completedDate: Date = Date(), type: AchievementType) {
        self.id = UUID()
        self.title = title
        self.skill = skill
        self.completedDate = completedDate
        self.type = type
    }
}

enum AchievementType: String, CaseIterable, Codable {
    case courseCompleted = "Course Completed"
    case skillMastered = "Skill Mastered"
    case goalAchieved = "Goal Achieved"
}

struct ProgressData: Codable {
    let dailyActivity: [ActivityPoint]
    let skillDistribution: [SkillProgress]
    let achievements: [Achievement]
    let totalCoursesCompleted: Int
    let totalTimeSpent: TimeInterval
}

struct ActivityPoint: Identifiable, Codable {
    let id: UUID
    let date: Date
    let value: Double
    
    init(id: UUID = UUID(), date: Date, value: Double) {
        self.id = id
        self.date = date
        self.value = value
    }
}

struct SkillProgress: Identifiable, Codable {
    let id: UUID
    let skill: String
    let timeSpent: TimeInterval
    let percentage: Double
    
    init(id: UUID = UUID(), skill: String, timeSpent: TimeInterval, percentage: Double) {
        self.id = id
        self.skill = skill
        self.timeSpent = timeSpent
        self.percentage = percentage
    }
}
