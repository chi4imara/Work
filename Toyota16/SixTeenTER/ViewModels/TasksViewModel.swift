import SwiftUI
import Combine

class TasksViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = []
    @Published var challenges: [TaskModel] = []
    @Published var showingAddItem = false
    @Published var selectedTask: TaskModel?
    
    private let dataManager = DataManager.shared
    
    init() {
        loadTasks()
    }
    
    var allItems: [TaskModel] {
        return (tasks + challenges).sorted { $0.createdDate > $1.createdDate }
    }
    
    var activeTasks: [TaskModel] {
        return tasks.filter { $0.type == .task }
    }
    
    var activeChallenges: [TaskModel] {
        return challenges.filter { $0.type == .challenge }
    }
    
    func task(byId id: UUID) -> TaskModel? {
        (tasks + challenges).first { $0.id == id }
    }
    
    func loadTasks() {
        let allTasks = dataManager.getTasks()
        tasks = allTasks.filter { $0.type == .task }
        challenges = allTasks.filter { $0.type == .challenge }
    }
    
    func addTask(_ task: TaskModel) {
        if task.type == .task {
            tasks.append(task)
        } else {
            challenges.append(task)
        }
        dataManager.saveTask(task)
    }
    
    func updateTask(_ task: TaskModel) {
        tasks.removeAll { $0.id == task.id }
        challenges.removeAll { $0.id == task.id }
        if task.type == .task {
            tasks.append(task)
        } else {
            challenges.append(task)
        }
        dataManager.saveTask(task)
    }
    
    func deleteTask(_ task: TaskModel) {
        if task.type == .task {
            tasks.removeAll { $0.id == task.id }
        } else {
            challenges.removeAll { $0.id == task.id }
        }
        dataManager.deleteTask(task.id)
    }
    
    func toggleTaskCompletion(_ task: TaskModel) {
        var updatedTask = task
        if updatedTask.isCompleted {
            updatedTask.markIncomplete()
        } else {
            updatedTask.markCompleted()
        }
        updateTask(updatedTask)
        var todayProgress = dataManager.getDailyProgress(for: Date())
        if updatedTask.isCompleted {
            if updatedTask.type == .task {
                if !todayProgress.completedTasks.contains(where: { $0.id == updatedTask.id }) {
                    todayProgress.completedTasks.append(updatedTask)
                }
            } else {
                if !todayProgress.completedChallenges.contains(where: { $0.id == updatedTask.id }) {
                    todayProgress.completedChallenges.append(updatedTask)
                }
            }
        } else {
            todayProgress.completedTasks.removeAll { $0.id == updatedTask.id }
            todayProgress.completedChallenges.removeAll { $0.id == updatedTask.id }
        }
        dataManager.saveDailyProgress(todayProgress)
    }
    
    func getStreakText(for task: TaskModel) -> String {
        if task.streakDays > 0 {
            return "\(task.streakDays) day\(task.streakDays == 1 ? "" : "s") streak"
        }
        return "No streak yet"
    }
    
    func getPriorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .low:
            return AppConstants.lowPriorityColor
        case .medium:
            return AppConstants.mediumPriorityColor
        case .high:
            return AppConstants.highPriorityColor
        }
    }
}
