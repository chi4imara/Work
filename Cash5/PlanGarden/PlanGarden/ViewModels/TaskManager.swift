import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [GardenTask] = []
    @Published var selectedCultures: Set<String> = []
    @Published var selectedWorkTypes: Set<WorkType> = []
    @Published var searchText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "SavedTasks"
    
    init() {
        loadTasks()
        addSampleTasks()
    }
    
    func addTask(_ task: GardenTask) {
        tasks.append(task)
        saveTasks()
    }
    
    func updateTask(_ task: GardenTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    func deleteTask(_ task: GardenTask) {
        var updatedTask = task
        updatedTask.archive()
        updateTask(updatedTask)
    }
    
    func restoreTask(_ task: GardenTask) {
        var updatedTask = task
        updatedTask.restore()
        updateTask(updatedTask)
    }
    
    func permanentlyDeleteTask(_ task: GardenTask) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func markTaskCompleted(_ task: GardenTask, for date: Date = Date()) {
        var updatedTask = task
        updatedTask.markCompleted(for: date)
        updateTask(updatedTask)
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func markTaskNotCompleted(_ task: GardenTask, for date: Date = Date()) {
        var updatedTask = task
        updatedTask.markNotCompleted(for: date)
        updateTask(updatedTask)
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func tasksForToday() -> [GardenTask] {
        let today = Date()
        return tasks.filter { task in
            task.status != .archived &&
            task.isRelevantFor(date: today) &&
            matchesFilters(task)
        }.sorted { task1, task2 in
            let completed1 = task1.isCompletedFor(date: today)
            let completed2 = task2.isCompletedFor(date: today)
            
            if completed1 != completed2 {
                return !completed1
            }
            
            if let time1 = task1.time, let time2 = task2.time {
                return time1 < time2
            } else if task1.time != nil {
                return true
            } else if task2.time != nil {
                return false
            } else {
                return task1.culture.name < task2.culture.name
            }
        }
    }
    
    func tasksForDate(_ date: Date) -> [GardenTask] {
        return tasks.filter { task in
            task.status != .archived &&
            task.isRelevantFor(date: date) &&
            matchesFilters(task)
        }.sorted { task1, task2 in
            let completed1 = task1.isCompletedFor(date: date)
            let completed2 = task2.isCompletedFor(date: date)
            
            if completed1 != completed2 {
                return !completed1
            }
            
            if let time1 = task1.time, let time2 = task2.time {
                return time1 < time2
            } else if task1.time != nil {
                return true
            } else if task2.time != nil {
                return false
            } else {
                return task1.culture.name < task2.culture.name
            }
        }
    }
    
    func archivedTasks() -> [GardenTask] {
        return tasks.filter { task in
            task.status == .archived &&
            matchesArchiveFilters(task)
        }.sorted { task1, task2 in
            guard let date1 = task1.archivedDate, let date2 = task2.archivedDate else {
                return false
            }
            return date1 > date2
        }
    }
    
    private func matchesFilters(_ task: GardenTask) -> Bool {
        let cultureMatch = selectedCultures.isEmpty || selectedCultures.contains(task.culture.name)
        let workTypeMatch = selectedWorkTypes.isEmpty || selectedWorkTypes.contains(task.workType)
        return cultureMatch && workTypeMatch
    }
    
    private func matchesArchiveFilters(_ task: GardenTask) -> Bool {
        let workTypeMatch = selectedWorkTypes.isEmpty || selectedWorkTypes.contains(task.workType)
        let searchMatch = searchText.isEmpty || 
                         task.culture.name.localizedCaseInsensitiveContains(searchText) ||
                         task.note.localizedCaseInsensitiveContains(searchText)
        return workTypeMatch && searchMatch
    }
    
    func clearFilters() {
        selectedCultures.removeAll()
        selectedWorkTypes.removeAll()
        searchText = ""
    }
    
    func clearCompletedTasks() {
        let today = Date()
        let todayString = DateFormatter.dayFormatter.string(from: today)
        
        for i in 0..<tasks.count {
            if tasks[i].completedDates.contains(todayString) {
                tasks[i].archive()
            }
        }
        saveTasks()
    }
    
    func clearArchive() {
        tasks.removeAll { $0.status == .archived }
        saveTasks()
    }
    
    func availableCultures() -> [String] {
        let activeTasks = tasks.filter { $0.status != .archived }
        let cultures = Set(activeTasks.map { $0.culture.name })
        return Array(cultures).sorted()
    }
    
    func availableWorkTypes() -> [WorkType] {
        let activeTasks = tasks.filter { $0.status != .archived }
        let workTypes = Set(activeTasks.map { $0.workType })
        return Array(workTypes).sorted { $0.rawValue < $1.rawValue }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            userDefaults.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let data = userDefaults.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([GardenTask].self, from: data) {
            tasks = decodedTasks
        }
    }
    
    private func addSampleTasks() {
        guard tasks.isEmpty else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        let sampleTasks = [
            GardenTask(
                culture: Culture(name: "Tomatoes"),
                workType: .watering,
                date: today,
                time: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today),
                frequency: .daily,
                note: "1 liter per plant"
            ),
            GardenTask(
                culture: Culture(name: "Cucumbers"),
                workType: .watering,
                date: today,
                time: calendar.date(bySettingHour: 8, minute: 30, second: 0, of: today),
                frequency: .daily,
                note: "Check soil moisture first"
            ),
            GardenTask(
                culture: Culture(name: "Roses"),
                workType: .fertilizing,
                date: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                frequency: .weekly,
                weekDay: calendar.component(.weekday, from: calendar.date(byAdding: .day, value: 1, to: today) ?? today),
                note: "Use rose fertilizer"
            ),
            GardenTask(
                culture: Culture(name: "Herbs"),
                workType: .pruning,
                date: calendar.date(byAdding: .day, value: 2, to: today) ?? today,
                frequency: .once,
                note: "Harvest basil and oregano"
            )
        ]
        
        tasks = sampleTasks
        saveTasks()
    }
}
