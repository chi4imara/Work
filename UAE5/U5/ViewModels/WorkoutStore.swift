import Foundation
import SwiftUI
import Combine

class WorkoutStore: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var workoutSessions: [WorkoutSession] = []
    
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "SavedWorkouts"
    private let sessionsKey = "WorkoutSessions"
    
    init() {
        loadWorkouts()
        loadSessions()
    }
    
    func addWorkout(_ workout: Workout) {
        objectWillChange.send()
        workouts.append(workout)
        saveWorkouts()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            objectWillChange.send()
            workouts[index] = workout
            saveWorkouts()
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        objectWillChange.send()
        workouts.removeAll { $0.id == workout.id }
        workoutSessions.removeAll { $0.workoutId == workout.id }
        saveWorkouts()
        saveSessions()
    }
    
    func completeWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            objectWillChange.send()
            workouts[index].lastPerformed = Date()
            let session = WorkoutSession(workout: workouts[index])
            workoutSessions.append(session)
            saveWorkouts()
            saveSessions()
        }
    }
    
    private func saveWorkouts() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            userDefaults.set(encoded, forKey: workoutsKey)
        }
    }
    
    private func loadWorkouts() {
        if let data = userDefaults.data(forKey: workoutsKey),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            workouts = decoded
        }
    }
    
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(workoutSessions) {
            userDefaults.set(encoded, forKey: sessionsKey)
        }
    }
    
    private func loadSessions() {
        if let data = userDefaults.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([WorkoutSession].self, from: data) {
            workoutSessions = decoded
        }
    }
    
    var lastCompletedWorkout: WorkoutSession? {
        workoutSessions.sorted { $0.performedAt > $1.performedAt }.first
    }
    
    var sessionsByMonth: [String: [WorkoutSession]] {
        Dictionary(grouping: workoutSessions.sorted { $0.performedAt > $1.performedAt }) { $0.monthYear }
    }
    
    var completedDates: Set<Date> {
        Set(workoutSessions.map { Calendar.current.startOfDay(for: $0.performedAt) })
    }
    
    func sessionsForDate(_ date: Date) -> [WorkoutSession] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return workoutSessions.filter { session in
            session.performedAt >= startOfDay && session.performedAt < endOfDay
        }
    }
    
    var allExercises: [String: Int] {
        var exerciseCount: [String: Int] = [:]
        
        for workout in workouts {
            for exercise in workout.exercises {
                exerciseCount[exercise.name, default: 0] += 1
            }
        }
        
        return exerciseCount
    }
    
    func workoutsContaining(exercise: String) -> [Workout] {
        workouts.filter { workout in
            workout.exercises.contains { $0.name == exercise }
        }
    }
}
