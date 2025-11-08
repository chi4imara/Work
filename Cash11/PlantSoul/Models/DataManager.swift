import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let plants = "saved_plants"
        static let tasks = "saved_tasks"
        static let instructions = "saved_instructions"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
    }
    
    private init() {}
    
    func savePlants(_ plants: [Plant]) {
        do {
            let data = try JSONEncoder().encode(plants)
            userDefaults.set(data, forKey: Keys.plants)
        } catch {
            print("Ошибка при сохранении растений: \(error)")
        }
    }
    
    func loadPlants() -> [Plant] {
        guard let data = userDefaults.data(forKey: Keys.plants) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Plant].self, from: data)
        } catch {
            print("Ошибка при загрузке растений: \(error)")
            return []
        }
    }
    
    func saveTasks(_ tasks: [Task]) {
        do {
            let data = try JSONEncoder().encode(tasks)
            userDefaults.set(data, forKey: Keys.tasks)
        } catch {
            print("Ошибка при сохранении задач: \(error)")
        }
    }
    
    func loadTasks() -> [Task] {
        guard let data = userDefaults.data(forKey: Keys.tasks) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Ошибка при загрузке задач: \(error)")
            return []
        }
    }
    
    func saveInstructions(_ instructions: [Instruction]) {
        do {
            let data = try JSONEncoder().encode(instructions)
            userDefaults.set(data, forKey: Keys.instructions)
        } catch {
            print("Ошибка при сохранении инструкций: \(error)")
        }
    }
    
    func loadInstructions() -> [Instruction] {
        guard let data = userDefaults.data(forKey: Keys.instructions) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Instruction].self, from: data)
        } catch {
            print("Ошибка при загрузке инструкций: \(error)")
            return []
        }
    }
    
    func saveOnboardingStatus(_ completed: Bool) {
        userDefaults.set(completed, forKey: Keys.hasCompletedOnboarding)
    }
    
    func loadOnboardingStatus() -> Bool {
        return userDefaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
    
    func clearAllData() {
        userDefaults.removeObject(forKey: Keys.plants)
        userDefaults.removeObject(forKey: Keys.tasks)
        userDefaults.removeObject(forKey: Keys.instructions)
        userDefaults.removeObject(forKey: Keys.hasCompletedOnboarding)
    }
    
    func hasStoredData() -> Bool {
        return userDefaults.data(forKey: Keys.plants) != nil ||
               userDefaults.data(forKey: Keys.tasks) != nil ||
               userDefaults.data(forKey: Keys.instructions) != nil
    }
}
