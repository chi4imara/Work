import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var selectedDate = Date()
    @Published var currentMonth = Date()
    @Published var selectedFilters: Set<TaskStatus> = Set(TaskStatus.allCases)
    
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "SavedTasks"
    
    init() {
        loadTasks()
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
    
    func tasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            calendar.isDate(task.deadline, inSameDayAs: date) &&
            selectedFilters.contains(task.actualStatus)
        }.sorted { $0.deadline < $1.deadline }
    }
    
    func allFilteredTasks() -> [Task] {
        let filteredTasks = tasks.filter { selectedFilters.contains($0.actualStatus) }
        
        return filteredTasks.sorted { task1, task2 in
            let status1 = task1.actualStatus
            let status2 = task2.actualStatus
            
            if status1 == .overdue && status2 != .overdue {
                return true
            } else if status1 != .overdue && status2 == .overdue {
                return false
            } else if status1 == .completed && status2 != .completed {
                return false
            } else if status1 != .completed && status2 == .completed {
                return true
            } else {
                return task1.deadline < task2.deadline
            }
        }
    }
    
    func dayStatus(for date: Date) -> TaskDayStatus {
        let dayTasks = tasksForDateIgnoringFilters(date)
        
        if dayTasks.isEmpty {
            return .none
        }
        
        let hasOverdue = dayTasks.contains { $0.actualStatus == .overdue }
        let hasInProgress = dayTasks.contains { $0.actualStatus == .inProgress }
        let allCompleted = dayTasks.allSatisfy { $0.actualStatus == .completed }
        
        if hasOverdue {
            return .overdue
        } else if hasInProgress {
            return .inProgress
        } else if allCompleted {
            return .completed
        } else {
            return .none
        }
    }
    
    private func tasksForDateIgnoringFilters(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            calendar.isDate(task.deadline, inSameDayAs: date)
        }
    }
    
    func taskStatistics() -> TaskStatistics {
        let completed = tasks.filter { $0.actualStatus == .completed }.count
        let inProgress = tasks.filter { $0.actualStatus == .inProgress }.count
        let overdue = tasks.filter { $0.actualStatus == .overdue }.count
        
        return TaskStatistics(
            total: tasks.count,
            completed: completed,
            inProgress: inProgress,
            overdue: overdue
        )
    }
    
    func tasksForStatus(_ status: TaskStatus) -> [Task] {
        return tasks.filter { $0.actualStatus == status }
            .sorted { $0.deadline < $1.deadline }
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
        } else {
            tasks = Task.sampleTasks
        }
    }
}

enum TaskDayStatus {
    case none
    case completed
    case inProgress
    case overdue
}

struct TaskStatistics {
    let total: Int
    let completed: Int
    let inProgress: Int
    let overdue: Int
    
    var completedPercentage: Double {
        total > 0 ? Double(completed) / Double(total) : 0
    }
    
    var inProgressPercentage: Double {
        total > 0 ? Double(inProgress) / Double(total) : 0
    }
    
    var overduePercentage: Double {
        total > 0 ? Double(overdue) / Double(total) : 0
    }
}
