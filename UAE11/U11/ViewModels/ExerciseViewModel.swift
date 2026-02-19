import Foundation
import Combine

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let dataManager = DataManager.shared
    
    init() {
        loadExercises()
    }
    
    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return exercises
        } else {
            return exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func loadExercises() {
        exercises = dataManager.loadExercises()
    }
    
    func addExercise(name: String, weight: Double, reps: Int) {
        var newExercise = Exercise(name: name)
        let firstResult = WorkoutResult(weight: weight, reps: reps)
        newExercise.results.append(firstResult)
        
        exercises.append(newExercise)
        dataManager.saveExercises(exercises)
    }
    
    func addResult(to exercise: Exercise, weight: Double, reps: Int) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            let newResult = WorkoutResult(weight: weight, reps: reps)
            exercises[index].results.append(newResult)
            dataManager.saveExercises(exercises)
        }
    }
    
    func deleteExercise(_ exercise: Exercise) {
        exercises.removeAll { $0.id == exercise.id }
        dataManager.saveExercises(exercises)
    }
    
    func updateExercise(_ exercise: Exercise, newName: String) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            exercises[index].name = newName
            dataManager.saveExercises(exercises)
        }
    }
    
    func deleteResult(_ result: WorkoutResult, from exercise: Exercise) {
        if let exerciseIndex = exercises.firstIndex(where: { $0.id == exercise.id }) {
            exercises[exerciseIndex].results.removeAll { $0.id == result.id }
            dataManager.saveExercises(exercises)
        }
    }
    
    func resetAllData() {
        exercises.removeAll()
        dataManager.saveExercises(exercises)
    }
    
    var totalExercises: Int {
        return exercises.count
    }
    
    var totalRecords: Int {
        return exercises.reduce(0) { $0 + $1.totalRecords }
    }
    
    var mostFrequentTrainingDay: String {
        let allDates = exercises.flatMap { $0.results.map { $0.date } }
        let calendar = Calendar.current
        let weekdays = allDates.map { calendar.component(.weekday, from: $0) }
        
        let weekdayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        let weekdayCounts = Dictionary(grouping: weekdays, by: { $0 })
            .mapValues { $0.count }
        
        if let mostFrequent = weekdayCounts.max(by: { $0.value < $1.value }) {
            return weekdayNames[mostFrequent.key - 1]
        }
        
        return "No data"
    }
}
