import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var selectedDate = Date()
    @Published var selectedTaskTypes: Set<TaskType> = Set(TaskType.allCases)
    @Published var showingTaskDetail = false
    @Published var showingAddTask = false
    
    private let dataManager = DataManager.shared
    
    var tasksForSelectedDate: [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            !task.isArchived &&
            calendar.isDate(task.date, inSameDayAs: selectedDate) &&
            selectedTaskTypes.contains(task.type)
        }.sorted { task1, task2 in
            if task1.isCompleted != task2.isCompleted {
                return !task1.isCompleted && task2.isCompleted
            }
            if task1.type != task2.type {
                return task1.type.rawValue < task2.type.rawValue
            }
            if let time1 = task1.time, let time2 = task2.time {
                return time1 < time2
            }
            return task1.time != nil && task2.time == nil
        }
    }
    
    var tasksForMonth: [Task] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
        let endOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.end ?? selectedDate
        
        return tasks.filter { task in
            !task.isArchived &&
            task.date >= startOfMonth &&
            task.date <= endOfMonth &&
            selectedTaskTypes.contains(task.type)
        }
    }
    
    var completedTasks: [Task] {
        return tasks.filter { $0.isCompleted && !$0.isArchived }
    }
    
    var favoriteTasks: [Task] {
        return tasks.filter { $0.isFavorite && !$0.isArchived }
    }
    
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
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            tasks[index].completedDate = tasks[index].isCompleted ? Date() : nil
            saveTasks()
        }
    }
    
    func toggleTaskFavorite(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isFavorite.toggle()
            saveTasks()
        }
    }
    
    func archiveTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isArchived = true
            saveTasks()
        }
    }
    
    func restoreTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isArchived = false
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func permanentDeleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func tasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            !task.isArchived &&
            calendar.isDate(task.date, inSameDayAs: date) &&
            selectedTaskTypes.contains(task.type)
        }
    }
    
    func clearCompletedTasksForMonth() {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.start ?? selectedDate
        let endOfMonth = calendar.dateInterval(of: .month, for: selectedDate)?.end ?? selectedDate
        
        for index in tasks.indices {
            if tasks[index].isCompleted &&
               !tasks[index].isArchived &&
               tasks[index].date >= startOfMonth &&
               tasks[index].date <= endOfMonth {
                tasks[index].isArchived = true
            }
        }
        saveTasks()
    }
    
    private func saveTasks() {
        dataManager.saveTasks(tasks)
    }
    
    private func loadTasks() {
        let savedTasks = dataManager.loadTasks()
        
        if savedTasks.isEmpty {
            loadSampleData()
        } else {
            tasks = savedTasks
        }
    }
    
    private func loadSampleData() {
        let calendar = Calendar.current
        let today = Date()
        
        tasks = [
            Task(plantId: UUID(), plantName: "Monstera Deliciosa", type: .watering, date: today, description: "Water thoroughly"),
            Task(plantId: UUID(), plantName: "Snake Plant", type: .watering, date: calendar.date(byAdding: .day, value: 1, to: today) ?? today),
            Task(plantId: UUID(), plantName: "Rose Bush", type: .fertilizing, date: calendar.date(byAdding: .day, value: 2, to: today) ?? today),
            Task(plantId: UUID(), plantName: "Water Lily", type: .cleaning, date: calendar.date(byAdding: .day, value: 3, to: today) ?? today)
        ]
        saveTasks()
    }
}

