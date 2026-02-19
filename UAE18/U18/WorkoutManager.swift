import Foundation
import SwiftUI
import Combine

class WorkoutManager: ObservableObject {
    @Published var workouts: [Workout] = []
    
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "SavedWorkouts"
    
    init() {
        loadWorkouts()
    }
    
    private func saveWorkouts() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            userDefaults.set(encoded, forKey: workoutsKey)
        }
    }
    
    private func loadWorkouts() {
        if let data = userDefaults.data(forKey: workoutsKey),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            workouts = decoded.sorted { $0.date > $1.date }
        }
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        workouts.sort { $0.date > $1.date }
        saveWorkouts()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            workouts.sort { $0.date > $1.date }
            saveWorkouts()
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        saveWorkouts()
    }
    
    func filteredWorkouts(by filter: WorkoutFilter) -> [Workout] {
        guard let exerciseType = filter.exerciseType else {
            return workouts
        }
        
        return workouts.filter { workout in
            workout.exercises.contains { $0.type == exerciseType }
        }
    }
    
    func workoutsForPeriod(_ period: ProgressPeriod) -> [Workout] {
        guard let days = period.days else {
            return workouts
        }
        
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return workouts.filter { $0.date >= cutoffDate }
    }
    
    func getBestResult(for exerciseType: ExerciseType, in period: ProgressPeriod = .all) -> Int {
        let periodWorkouts = workoutsForPeriod(period)
        let results = periodWorkouts.compactMap { $0.getResult(for: exerciseType) }
        return results.max() ?? 0
    }
    
    func getAverageResult(for exerciseType: ExerciseType, in period: ProgressPeriod = .all) -> Double {
        let periodWorkouts = workoutsForPeriod(period)
        let results = periodWorkouts.compactMap { $0.getResult(for: exerciseType) }
        guard !results.isEmpty else { return 0 }
        return Double(results.reduce(0, +)) / Double(results.count)
    }
    
    func getWorkoutCount(for exerciseType: ExerciseType, in period: ProgressPeriod = .all) -> Int {
        let periodWorkouts = workoutsForPeriod(period)
        return periodWorkouts.filter { $0.getResult(for: exerciseType) != nil }.count
    }
    
    func getLastWorkoutDate(for exerciseType: ExerciseType) -> Date? {
        return workouts.first { $0.getResult(for: exerciseType) != nil }?.date
    }
    
    func getProgressData(for exerciseType: ExerciseType, in period: ProgressPeriod = .all) -> [(Date, Int)] {
        let periodWorkouts = workoutsForPeriod(period)
        return periodWorkouts.compactMap { workout in
            guard let result = workout.getResult(for: exerciseType) else { return nil }
            return (workout.date, result)
        }.sorted { $0.0 < $1.0 }
    }
    
    func isPersonalBest(_ workout: Workout, for exerciseType: ExerciseType) -> Bool {
        guard let currentResult = workout.getResult(for: exerciseType) else { return false }
        
        let previousWorkouts = workouts.filter { $0.date < workout.date }
        let previousBest = previousWorkouts.compactMap { $0.getResult(for: exerciseType) }.max() ?? 0
        
        return currentResult > previousBest
    }
    
    func hasPersonalBest(_ workout: Workout) -> Bool {
        return ExerciseType.allCases.contains { exerciseType in
            isPersonalBest(workout, for: exerciseType)
        }
    }
    
    func getProgressStats(for exerciseType: ExerciseType, in period: ProgressPeriod = .all) -> ProgressStats {
        let periodWorkouts = workoutsForPeriod(period)
        return ProgressStats(workouts: periodWorkouts, exerciseType: exerciseType)
    }
}
