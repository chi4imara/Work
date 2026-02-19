import Foundation
import SwiftUI
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var selectedMuscleGroupFilter: MuscleGroup? = nil
    @Published var selectedTimePeriod: TimePeriod = .month
    @Published var showOnboarding: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let workoutsKey = "SavedWorkouts"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadWorkouts()
        loadOnboardingStatus()
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
    
    private func loadOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        showOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        workouts.sort { $0.date > $1.date }
        saveWorkouts()
        objectWillChange.send()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            workouts.sort { $0.date > $1.date }
            saveWorkouts()
            objectWillChange.send()
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        saveWorkouts()
        objectWillChange.send()
    }
    
    var filteredWorkouts: [Workout] {
        guard let filter = selectedMuscleGroupFilter else {
            return workouts
        }
        return workouts.filter { $0.muscleGroups.contains(filter) }
    }
    
    var progressStats: ProgressStats {
        let filteredByPeriod = workoutsInTimePeriod(selectedTimePeriod)
        
        let muscleGroupCounts = Dictionary(grouping: workouts) { workout in
            workout.muscleGroups
        }.mapValues { $0.count }
        
        let mostTrainedGroup = muscleGroupCounts.max { $0.value < $1.value }?.key.first
        
        let uniqueGroups = Set(workouts.flatMap { $0.muscleGroups }).count
        
        let workoutsByDate = Dictionary(grouping: filteredByPeriod) { workout in
            Calendar.current.startOfDay(for: workout.date)
        }.mapValues { $0.count }
        
        return ProgressStats(
            totalWorkouts: filteredByPeriod.count,
            lastVisitDate: workouts.first?.date,
            mostTrainedMuscleGroup: mostTrainedGroup,
            uniqueMuscleGroups: uniqueGroups,
            workoutsInPeriod: workoutsByDate
        )
    }
    
    private func workoutsInTimePeriod(_ period: TimePeriod) -> [Workout] {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return workouts.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return workouts.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return workouts.filter { $0.date >= yearAgo }
        case .all:
            return workouts
        }
    }
    
    func isLastVisit(_ workout: Workout) -> Bool {
        return workout.id == workouts.first?.id
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
