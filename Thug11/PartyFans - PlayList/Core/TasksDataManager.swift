import Foundation

class TasksDataManager {
    static let shared = TasksDataManager()
    
    private let userDefaults = UserDefaults.standard
    private let tasksKey = "PartyTasks"
    
    private init() {}
    
    func saveTasks(_ tasks: [PartyTask]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            userDefaults.set(data, forKey: tasksKey)
        } catch {
            print("Error saving tasks: \(error)")
        }
    }
    
    func loadTasks() -> [PartyTask] {
        guard let data = userDefaults.data(forKey: tasksKey) else {
            return []
        }
        
        do {
            let tasks = try JSONDecoder().decode([PartyTask].self, from: data)
            return tasks
        } catch {
            print("Error loading tasks: \(error)")
            return []
        }
    }
    
    func addTask(_ task: PartyTask) {
        var tasks = loadTasks()
        tasks.append(task)
        saveTasks(tasks)
    }
    
    func updateTask(_ updatedTask: PartyTask) {
        var tasks = loadTasks()
        if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
            tasks[index] = updatedTask
            saveTasks(tasks)
        }
    }
    
    func deleteTask(withId id: UUID) {
        var tasks = loadTasks()
        tasks.removeAll { $0.id == id }
        saveTasks(tasks)
    }
    
    func deleteAllTasks() {
        saveTasks([])
    }
    
    static var preview: TasksDataManager = {
        let manager = TasksDataManager()
        
        let sampleTask = PartyTask(
            text: "Sing your favorite song",
            category: TaskCategory.singing.rawValue
        )
        manager.addTask(sampleTask)
        
        return manager
    }()
}
