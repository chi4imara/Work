import Foundation

class DataManager {
    static let shared = DataManager()
    private let exercisesKey = "SavedExercises"
    
    private init() {}
    
    func saveExercises(_ exercises: [Exercise]) {
        if let encoded = try? JSONEncoder().encode(exercises) {
            UserDefaults.standard.set(encoded, forKey: exercisesKey)
        }
    }
    
    func loadExercises() -> [Exercise] {
        if let data = UserDefaults.standard.data(forKey: exercisesKey),
           let exercises = try? JSONDecoder().decode([Exercise].self, from: data) {
            return exercises
        }
        return []
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: exercisesKey)
    }
}
