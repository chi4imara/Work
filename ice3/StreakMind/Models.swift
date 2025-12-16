import Foundation
import SwiftUI

enum HabitCategory: String, CaseIterable, Identifiable, Codable {
    case food = "Food"
    case technology = "Technology"
    case health = "Health"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .food:
            return "fork.knife"
        case .technology:
            return "iphone"
        case .health:
            return "heart.fill"
        case .other:
            return "star.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food:
            return AppColors.accentYellow
        case .technology:
            return Color.blue
        case .health:
            return AppColors.successGreen
        case .other:
            return AppColors.neutralGray
        }
    }
}

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: HabitCategory
    var comment: String
    var startDate: Date
    var currentStreak: Int
    var maxStreak: Int
    var lastCheckedDate: Date?
    var isInTrophies: Bool
    var checkedDates: Set<String>
    
    init(name: String, category: HabitCategory, comment: String = "", startDate: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.comment = comment
        self.startDate = startDate
        self.currentStreak = 0
        self.maxStreak = 0
        self.lastCheckedDate = nil
        self.isInTrophies = false
        self.checkedDates = []
    }
    
    var canCheckToday: Bool {
        guard let lastChecked = lastCheckedDate else { return true }
        return !Calendar.current.isDate(lastChecked, inSameDayAs: Date())
    }
    
    var nextMilestone: Int {
        let milestones = [7, 14, 30, 60, 100, 365]
        return milestones.first { $0 > currentStreak } ?? 1000
    }
    
    var progressToNextMilestone: Double {
        let previous = currentStreak == 0 ? 0 : 
            [0, 7, 14, 30, 60, 100, 365].last { $0 <= currentStreak } ?? 0
        let next = nextMilestone
        let progress = Double(currentStreak - previous) / Double(next - previous)
        return min(max(progress, 0), 1)
    }
    
    var shouldBeInTrophies: Bool {
        return maxStreak >= 7
    }
    
    mutating func checkToday() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        guard canCheckToday else { return }
        
        checkedDates.insert(todayString)
        lastCheckedDate = today
        
        currentStreak = calculateCurrentStreak()
        maxStreak = max(maxStreak, currentStreak)
    }
    
    mutating func resetStreak() {
        currentStreak = 0
        lastCheckedDate = nil
    }
    
    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var streak = 0
        var currentDate = Date()
        
        while true {
            let dateString = dateFormatter.string(from: currentDate)
            if checkedDates.contains(dateString) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let habitId: UUID
    let milestone: Int
    let achievedDate: Date
    let habitName: String
    let habitCategory: HabitCategory
    
    init(habitId: UUID, milestone: Int, achievedDate: Date, habitName: String, habitCategory: HabitCategory) {
        self.id = UUID()
        self.habitId = habitId
        self.milestone = milestone
        self.achievedDate = achievedDate
        self.habitName = habitName
        self.habitCategory = habitCategory
    }
}

enum DayStatus {
    case checked
    case missed
    case future
}

struct CalendarDay: Identifiable {
    let id: UUID
    let date: Date
    let status: DayStatus
    let habits: [Habit]
    
    init(date: Date, status: DayStatus, habits: [Habit]) {
        self.id = UUID()
        self.date = date
        self.status = status
        self.habits = habits
    }
}
