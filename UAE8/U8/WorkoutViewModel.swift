import Foundation
import SwiftUI
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var history: [HistoryEntry] = []
    @Published var isFirstLaunch: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    
    private let workoutsKey = "SavedWorkouts"
    private let historyKey = "WorkoutHistory"
    private let firstLaunchKey = "IsFirstLaunch"
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        loadData()
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: workoutsKey),
           let decodedWorkouts = try? JSONDecoder().decode([Workout].self, from: data) {
            workouts = decodedWorkouts
        }
        
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            history = decodedHistory
        }
        
        isFirstLaunch = !UserDefaults.standard.bool(forKey: firstLaunchKey)
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    private func saveWorkouts() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: workoutsKey)
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.removeAll { $0.day == workout.day }
        workouts.append(workout)
        saveWorkouts()
        
        let historyEntry = HistoryEntry(
            day: workout.day,
            workoutType: workout.type,
            note: workout.note,
            actionType: .added,
            date: Date()
        )
        history.append(historyEntry)
        saveHistory()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            workouts[index].lastModified = Date()
            saveWorkouts()
            
            let historyEntry = HistoryEntry(
                day: workout.day,
                workoutType: workout.type,
                note: workout.note,
                actionType: .modified,
                date: Date()
            )
            history.append(historyEntry)
            saveHistory()
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        saveWorkouts()
    }
    
    func markWorkoutCompleted(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].isCompleted = true
            workouts[index].completedDate = Date()
            saveWorkouts()
            
            let historyEntry = HistoryEntry(
                day: workout.day,
                workoutType: workout.type,
                note: workout.note,
                actionType: .completed,
                date: Date()
            )
            history.append(historyEntry)
            saveHistory()
        }
    }
    
    func workout(for day: DayOfWeek) -> Workout? {
        return workouts.first { $0.day == day }
    }
    
    func workout(id: UUID) -> Workout? {
        return workouts.first { $0.id == id }
    }
    
    func lastUpdatedWorkout() -> Workout? {
        return workouts.max { $0.lastModified < $1.lastModified }
    }
    
    func categorySummaries() -> [CategorySummary] {
        let groupedWorkouts = Dictionary(grouping: workouts) { $0.type }
        return groupedWorkouts.map { type, workouts in
            CategorySummary(
                type: type,
                count: workouts.count,
                days: workouts.map { $0.day }
            )
        }.sorted { $0.type.rawValue < $1.type.rawValue }
    }
    
    func groupedHistory() -> [String: [HistoryEntry]] {
        let sortedHistory = history.sorted { $0.date > $1.date }
        return Dictionary(grouping: sortedHistory) { $0.monthYear }
    }
    
    var hasWorkouts: Bool {
        return !workouts.isEmpty
    }
}
