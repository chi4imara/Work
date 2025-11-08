import Foundation
import Combine

class GoalsManager: ObservableObject {
    static let shared = GoalsManager()
    
    @Published var dailyMoodGoal: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var dailyWeatherGoal: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var dailyCommentGoal: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var minWeeklyEntries: Int = 5 {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var weeklyReviewGoal: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var minMonthlyEntries: Int = 20 {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    @Published var monthlyAnalysisGoal: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.saveSettings()
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let dataManager = DataManager.shared
    
    private init() {
        loadSettings()
    }
    
    private func loadSettings() {
        dailyMoodGoal = userDefaults.bool(forKey: "daily_mood_goal")
        dailyWeatherGoal = userDefaults.bool(forKey: "daily_weather_goal")
        dailyCommentGoal = userDefaults.bool(forKey: "daily_comment_goal")
        minWeeklyEntries = userDefaults.integer(forKey: "min_weekly_entries")
        if minWeeklyEntries == 0 { minWeeklyEntries = 5 }
        
        weeklyReviewGoal = userDefaults.bool(forKey: "weekly_review_goal")
        minMonthlyEntries = userDefaults.integer(forKey: "min_monthly_entries")
        if minMonthlyEntries == 0 { minMonthlyEntries = 20 }
        
        monthlyAnalysisGoal = userDefaults.bool(forKey: "monthly_analysis_goal")
    }
    
    func saveSettings() {
        userDefaults.set(dailyMoodGoal, forKey: "daily_mood_goal")
        userDefaults.set(dailyWeatherGoal, forKey: "daily_weather_goal")
        userDefaults.set(dailyCommentGoal, forKey: "daily_comment_goal")
        userDefaults.set(minWeeklyEntries, forKey: "min_weekly_entries")
        userDefaults.set(weeklyReviewGoal, forKey: "weekly_review_goal")
        userDefaults.set(minMonthlyEntries, forKey: "min_monthly_entries")
        userDefaults.set(monthlyAnalysisGoal, forKey: "monthly_analysis_goal")
    }
    
    var currentStreak: Int {
        let calendar = Calendar.current
        let today = Date()
        var streak = 0
        var currentDate = today
        
        while true {
            let hasEntry = dataManager.getEntry(for: currentDate) != nil
            if hasEntry {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    var weeklyEntries: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        return dataManager.entries.filter { entry in
            entry.date >= weekAgo
        }.count
    }
    
    var monthlyEntries: Int {
        let calendar = Calendar.current
        let now = Date()
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        
        return dataManager.entries.filter { entry in
            entry.date >= monthAgo
        }.count
    }
    
    var dailyGoalProgress: Double {
        let today = Date()
        let hasEntry = dataManager.getEntry(for: today) != nil
        return hasEntry ? 1.0 : 0.0
    }
    
    var weeklyGoalProgress: Double {
        let progress = Double(weeklyEntries) / Double(minWeeklyEntries)
        return min(progress, 1.0)
    }
    
    var monthlyGoalProgress: Double {
        let progress = Double(monthlyEntries) / Double(minMonthlyEntries)
        return min(progress, 1.0)
    }
    
    var isDailyGoalMet: Bool {
        return dailyGoalProgress >= 1.0
    }
    
    var isWeeklyGoalMet: Bool {
        return weeklyGoalProgress >= 1.0
    }
    
    var isMonthlyGoalMet: Bool {
        return monthlyGoalProgress >= 1.0
    }
    
    var achievements: [Achievement] {
        var achievements: [Achievement] = []
        
        if currentStreak >= 7 {
            achievements.append(Achievement(
                title: "Week Warrior",
                description: "7 day streak!",
                icon: "flame.fill",
                isUnlocked: true
            ))
        }
        
        if currentStreak >= 30 {
            achievements.append(Achievement(
                title: "Month Master",
                description: "30 day streak!",
                icon: "crown.fill",
                isUnlocked: true
            ))
        }
        
        if weeklyEntries >= minWeeklyEntries {
            achievements.append(Achievement(
                title: "Weekly Winner",
                description: "Met weekly goal!",
                icon: "star.fill",
                isUnlocked: true
            ))
        }
        
        return achievements
    }
}

struct Achievement {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
}
