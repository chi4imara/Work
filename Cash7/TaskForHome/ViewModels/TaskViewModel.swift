import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [CleaningTask] = []
    @Published var selectedRoomFilter: Set<Room> = Set(Room.allCases)
    @Published var showOnlyTodayTasks = true
    
    init() {
        loadTasks()
    }
    
    func addTask(_ task: CleaningTask) {
        tasks.append(task)
        objectWillChange.send()
        saveTasks()
    }
    
    func updateTask(_ task: CleaningTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            objectWillChange.send()
            saveTasks()
        }
    }
    
    func deleteTask(_ task: CleaningTask) {
        var updatedTask = task
        updatedTask.isArchived = true
        updatedTask.archivedDate = Date()
        updateTask(updatedTask)
        objectWillChange.send()
    }
    
    func toggleTaskCompletion(_ task: CleaningTask) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        updatedTask.completedDate = updatedTask.isCompleted ? Date() : nil
        updateTask(updatedTask)
        objectWillChange.send()
    }
    
    func restoreTask(_ task: CleaningTask) {
        var updatedTask = task
        updatedTask.isArchived = false
        updatedTask.archivedDate = nil
        updateTask(updatedTask)
    }
    
    func permanentlyDeleteTask(_ task: CleaningTask) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    var todayTasks: [CleaningTask] {
        return tasks.filter { task in
            !task.isArchived && task.isRelevantForToday()
        }.filter { task in
            selectedRoomFilter.contains(task.room) || (task.room == .other && selectedRoomFilter.contains(.other))
        }.sorted { first, second in
            if first.isCompleted != second.isCompleted {
                return !first.isCompleted
            }
            return first.displayRoom < second.displayRoom
        }
    }
    
    var archivedTasks: [CleaningTask] {
        return tasks.filter { $0.isArchived }.sorted { first, second in
            guard let firstDate = first.archivedDate, let secondDate = second.archivedDate else {
                return false
            }
            return firstDate > secondDate
        }
    }
    
    func tasksForRoom(_ room: Room) -> [CleaningTask] {
        return tasks.filter { task in
            !task.isArchived && task.room == room
        }.filter { task in
            showOnlyTodayTasks ? task.isRelevantForToday() : true
        }.sorted { first, second in
            if first.isCompleted != second.isCompleted {
                return !first.isCompleted
            }
            return first.title < second.title
        }
    }
    
    var roomsWithTasks: [Room] {
        let activeRooms = Set(tasks.filter { !$0.isArchived }.map { $0.room })
        return Room.allCases.filter { activeRooms.contains($0) }
    }
    
    func taskCountForRoom(_ room: Room) -> Int {
        return tasks.filter { !$0.isArchived && $0.room == room }.count
    }
    
    func clearCompletedTasks() {
        let completedTasks = tasks.filter { $0.isCompleted && !$0.isArchived }
        for task in completedTasks {
            deleteTask(task)
        }
    }
    
    func deleteSelectedTasks(_ selectedTasks: Set<CleaningTask>) {
        for task in selectedTasks {
            deleteTask(task)
        }
    }
    
    func restoreSelectedTasks(_ selectedTasks: Set<CleaningTask>) {
        for task in selectedTasks {
            restoreTask(task)
        }
    }
    
    func permanentlyDeleteSelectedTasks(_ selectedTasks: Set<CleaningTask>) {
        for task in selectedTasks {
            permanentlyDeleteTask(task)
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "CleaningTasks")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "CleaningTasks"),
           let decoded = try? JSONDecoder().decode([CleaningTask].self, from: data) {
            tasks = decoded
        }
    }
    
    var completionRate: Double {
        let activeTasks = tasks.filter { !$0.isArchived }
        guard !activeTasks.isEmpty else { return 0.0 }
        let completedTasks = activeTasks.filter { $0.isCompleted }
        return Double(completedTasks.count) / Double(activeTasks.count)
    }
    
    var todayCompletionRate: Double {
        let todayTasks = self.todayTasks
        guard !todayTasks.isEmpty else { return 0.0 }
        let completedToday = todayTasks.filter { $0.isCompleted }
        return Double(completedToday.count) / Double(todayTasks.count)
    }
    
    var totalActiveTasks: Int {
        return tasks.filter { !$0.isArchived }.count
    }
    
    var totalCompletedTasks: Int {
        return tasks.filter { $0.isCompleted && !$0.isArchived }.count
    }
    
    func resetDailyTasks() {
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<tasks.count {
            var task = tasks[i]
            
            if task.frequency == .daily && task.isCompleted {
                if let completedDate = task.completedDate,
                   !calendar.isDate(completedDate, inSameDayAs: today) {
                    task.isCompleted = false
                    task.completedDate = nil
                    tasks[i] = task
                }
            }
        }
        
        saveTasks()
    }
}
