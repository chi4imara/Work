import Foundation
import SwiftUI
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "SavedWorkouts"
    
    init() {
        loadWorkouts()
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        saveWorkouts()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            saveWorkouts()
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        saveWorkouts()
    }
    
    func deleteWorkout(at indexSet: IndexSet) {
        workouts.remove(atOffsets: indexSet)
        saveWorkouts()
    }
    
    func getStatistics() -> WorkoutStatistics? {
        guard !workouts.isEmpty else { return nil }
        
        let totalDistance = workouts.reduce(0) { $0 + $1.distance }
        let totalDuration = workouts.reduce(0) { $0 + $1.duration }
        let bestDistanceWorkout = workouts.max { $0.distance < $1.distance }
        let bestDurationWorkout = workouts.max { $0.duration < $1.duration }
        
        return WorkoutStatistics(
            totalDistance: totalDistance,
            totalDuration: totalDuration,
            bestDistanceWorkout: bestDistanceWorkout,
            bestDurationWorkout: bestDurationWorkout
        )
    }
    
    var hasWorkouts: Bool {
        return !workouts.isEmpty
    }
    
    var sortedWorkouts: [Workout] {
        return workouts.sorted { $0.date > $1.date }
    }
    
    func getWorkout(by id: UUID) -> Workout? {
        return workouts.first { $0.id == id }
    }
    
    func loadSampleData() {
        workouts = SampleData.workouts
        saveWorkouts()
    }
    
    func clearAllWorkouts() {
        workouts = []
        saveWorkouts()
    }
    
    func saveWorkouts() {
        do {
            let data = try JSONEncoder().encode(workouts)
            userDefaults.set(data, forKey: workoutsKey)
        } catch {
            print("Failed to save workouts: \(error)")
        }
    }
    
    private func loadWorkouts() {
        guard let data = userDefaults.data(forKey: workoutsKey) else { return }
        
        do {
            workouts = try JSONDecoder().decode([Workout].self, from: data)
        } catch {
            print("Failed to load workouts: \(error)")
        }
    }
}

class AppStateManager: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var isShowingSplash = true
    @Published var selectedTab = 0
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func hideSplash() {
        isShowingSplash = false
    }
}
