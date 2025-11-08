import Foundation
import SwiftUI
import Combine

class TasksViewModel: ObservableObject {
    private let dataManager = TasksDataManager.shared
    
    @Published var tasks: [PartyTask] = []
    @Published var currentRandomTask: PartyTask?
    @Published var isLoading = false
    
    init() {
        fetchTasks()
    }
    
    func fetchTasks() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.tasks = self.dataManager.loadTasks().sorted { $0.dateCreated > $1.dateCreated }
            
            if !self.tasks.isEmpty {
                self.generateRandomTask()
            } else {
                self.currentRandomTask = nil
            }
        }
    }
    
    func addTask(text: String, category: TaskCategory) {
        let newTask = PartyTask(
            text: text,
            category: category.rawValue
        )
        
        dataManager.addTask(newTask)
        fetchTasks()
    }
    
    func updateTask(_ task: PartyTask, text: String, category: TaskCategory) {
        let updatedTask = PartyTask(
            id: task.id,
            text: text,
            category: category.rawValue,
            dateCreated: task.dateCreated
        )
        
        dataManager.updateTask(updatedTask)
        fetchTasks()
    }
    
    func deleteTask(_ task: PartyTask) {
        let deletedTaskId = task.id
        
        let isDeletingCurrentTask = currentRandomTask?.id == deletedTaskId
        
        dataManager.deleteTask(withId: task.id)
        
        fetchTasks()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if isDeletingCurrentTask || self.tasks.isEmpty {
                self.currentRandomTask = nil
            }
            
            if !self.tasks.isEmpty {
                self.generateRandomTask()
            }
        }
    }
    
    func generateRandomTask() {
        guard !tasks.isEmpty else {
            currentRandomTask = nil
            return
        }
        
        let validTasks = tasks.filter { task in
            guard !task.text.isEmpty else { return false }
            guard !task.category.isEmpty else { return false }
            
            return true
        }
        
        if validTasks.isEmpty {
            currentRandomTask = nil
        } else {
            currentRandomTask = validTasks.randomElement()
        }
    }
    
    func getTasksByCategory(_ category: TaskCategory) -> [PartyTask] {
        return tasks.filter { task in
            return task.category == category.rawValue
        }
    }
    
    func getCategoryCount(_ category: TaskCategory) -> Int {
        return getTasksByCategory(category).count
    }
}
