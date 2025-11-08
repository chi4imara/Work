import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var currentFilter: TaskFilter = .all
    
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "SavedTasks"
    
    init() {
        loadTasks()
    }
    
    var filteredTasks: [Task] {
        switch currentFilter {
        case .all:
            return tasks.sorted { $0.createdAt > $1.createdAt }
        case .active:
            return tasks.filter { !$0.isCompleted }.sorted { $0.createdAt > $1.createdAt }
        case .completed:
            return tasks.filter { $0.isCompleted }.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    var tasksByCategory: [TaskCategory: [Task]] {
        Dictionary(grouping: tasks, by: { $0.category })
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var activeTasksCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    var totalTasksCount: Int {
        tasks.count
    }
    
    var tasksCompletedThisWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        return tasks.filter { task in
            task.isCompleted && task.createdAt >= weekAgo
        }.count
    }
    
    var tasksCreatedThisWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        return tasks.filter { task in
            task.createdAt >= weekAgo
        }.count
    }
    
    var averageTasksPerDay: Double {
        guard !tasks.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let firstTaskDate = tasks.map { $0.createdAt }.min() ?? Date()
        let daysSinceFirstTask = calendar.dateComponents([.day], from: firstTaskDate, to: Date()).day ?? 1
        
        return Double(tasks.count) / Double(max(daysSinceFirstTask, 1))
    }
    
    var mostProductiveCategory: TaskCategory? {
        let categoryStats = tasksByCategory.mapValues { tasks in
            tasks.filter { $0.isCompleted }.count
        }
        
        return categoryStats.max { $0.value < $1.value }?.key
    }
    
    var completionRateByCategory: [TaskCategory: Double] {
        var rates: [TaskCategory: Double] = [:]
        
        for category in TaskCategory.allCases {
            let categoryTasks = tasks.filter { $0.category == category }
            guard !categoryTasks.isEmpty else {
                rates[category] = 0
                continue
            }
            
            let completedCount = categoryTasks.filter { $0.isCompleted }.count
            rates[category] = Double(completedCount) / Double(categoryTasks.count)
        }
        
        return rates
    }
    
    var streakDays: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDate = today
        
        while true {
            let dayTasks = tasks.filter { task in
                calendar.isDate(task.createdAt, inSameDayAs: currentDate)
            }
            
            let hasCompletedTasks = dayTasks.contains { $0.isCompleted }
            
            if hasCompletedTasks {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    var recentActivity: [Date: Int] {
        let calendar = Calendar.current
        let last30Days = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        
        var activity: [Date: Int] = [:]
        
        for task in tasks where task.createdAt >= last30Days {
            let day = calendar.startOfDay(for: task.createdAt)
            activity[day, default: 0] += 1
        }
        
        return activity
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func setFilter(_ filter: TaskFilter) {
        currentFilter = filter
    }
    
    func tasksForCategory(_ category: TaskCategory) -> [Task] {
        return tasks.filter { $0.category == category }.sorted { $0.createdAt > $1.createdAt }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            userDefaults.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let data = userDefaults.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decodedTasks
        }
    }
}
