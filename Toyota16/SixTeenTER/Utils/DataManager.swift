import Foundation
import Combine

extension Notification.Name {
    static let dataManagerDidChange = Notification.Name("DataManagerDidChange")
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "SavedTasks"
    private let dailyProgressKey = "DailyProgress"
    
    private init() {}
        
    func getTasks() -> [TaskModel] {
        guard let data = userDefaults.data(forKey: tasksKey),
              let tasks = try? JSONDecoder().decode([TaskModel].self, from: data) else {
            return []
        }
        return tasks
    }
    
    func saveTask(_ task: TaskModel) {
        var tasks = getTasks()
        
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        } else {
            tasks.append(task)
        }
        
        if let data = try? JSONEncoder().encode(tasks) {
            userDefaults.set(data, forKey: tasksKey)
            NotificationCenter.default.post(name: .dataManagerDidChange, object: nil)
        }
    }
    
    func deleteTask(_ taskId: UUID) {
        var tasks = getTasks()
        tasks.removeAll { $0.id == taskId }
        
        if let data = try? JSONEncoder().encode(tasks) {
            userDefaults.set(data, forKey: tasksKey)
            NotificationCenter.default.post(name: .dataManagerDidChange, object: nil)
        }
    }
        
    func getAllDailyProgress() -> [DailyProgress] {
        guard let data = userDefaults.data(forKey: dailyProgressKey),
              let progressRecords = try? JSONDecoder().decode([DailyProgress].self, from: data) else {
            return []
        }
        return progressRecords
    }
    
    func getDailyProgress(for date: Date) -> DailyProgress {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let allProgress = getAllDailyProgress()
        
        if let existing = allProgress.first(where: { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }) {
            return existing
        }
        
        return DailyProgress(date: startOfDay)
    }
    
    func saveDailyProgress(_ progress: DailyProgress) {
        var allProgress = getAllDailyProgress()
        let startOfDay = Calendar.current.startOfDay(for: progress.date)
        
        if let index = allProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }) {
            allProgress[index] = progress
        } else {
            allProgress.append(progress)
        }
        
        if let data = try? JSONEncoder().encode(allProgress) {
            userDefaults.set(data, forKey: dailyProgressKey)
            NotificationCenter.default.post(name: .dataManagerDidChange, object: nil)
        }
    }
        
    func clearAllData() {
        userDefaults.removeObject(forKey: tasksKey)
        userDefaults.removeObject(forKey: dailyProgressKey)
    }
    
    func loadSampleData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let sampleTasks: [TaskModel] = [
            TaskModel(title: "Review priorities", type: .task, priority: .high, frequency: .daily, note: "Focus on top 3"),
            TaskModel(title: "Morning workout", type: .task, priority: .medium, frequency: .daily),
            TaskModel(title: "Read 20 pages", type: .task, priority: .low, frequency: .weekly),
            TaskModel(title: "5 minutes meditation", type: .challenge, priority: .medium, frequency: .daily),
            TaskModel(title: "Drink 8 glasses of water", type: .challenge, priority: .low, frequency: .daily),
        ]
        for var task in sampleTasks {
            task.createdDate = calendar.date(byAdding: .day, value: -7, to: Date()) ?? task.createdDate
            saveTask(task)
        }
        
        let sampleThoughts = ["Good day overall", "Focused on deep work", "Feeling productive", "Balanced day", "Strong morning", "Completed main goals", "Ready for weekend"]
        let sampleAchievements = ["Finished report", "Worked out", "Read 30 min", "Meditation done", "All tasks done", "Cleared inbox", "Planned next week"]
        
        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            
            var record = DailyEnergyRecord(date: startOfDay)
            record.energyLevels = [
                EnergyLevel(type: .energy, level: min(5, 3 + dayOffset % 3)),
                EnergyLevel(type: .motivation, level: 4),
                EnergyLevel(type: .concentration, level: 3 + dayOffset % 2),
            ]
            
            var completedTasksForDay: [TaskModel] = []
            var completedChallengesForDay: [TaskModel] = []
            for (index, var t) in sampleTasks.enumerated() {
                let completed = (dayOffset + index) % 3 != 0
                if !completed { continue }
                t.isCompleted = true
                t.completedDates = [day]
                t.streakDays = min(dayOffset + 1, 3)
                if t.type == .task {
                    completedTasksForDay.append(t)
                } else {
                    completedChallengesForDay.append(t)
                }
            }
            
            let diary = DiaryEntry(
                thoughts: sampleThoughts[dayOffset % sampleThoughts.count],
                achievements: sampleAchievements[dayOffset % sampleAchievements.count],
                date: startOfDay
            )
            
            var progress = DailyProgress(date: startOfDay)
            progress.energyRecord = record
            progress.completedTasks = completedTasksForDay
            progress.completedChallenges = completedChallengesForDay
            progress.diaryEntry = diary
            saveDailyProgress(progress)
        }
        
        NotificationCenter.default.post(name: .dataManagerDidChange, object: nil)
    }
    
    func exportData() -> [String: Any] {
        return [
            "tasks": getTasks(),
            "dailyProgress": getAllDailyProgress()
        ]
    }
}
